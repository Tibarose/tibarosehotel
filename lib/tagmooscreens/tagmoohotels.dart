import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TagmoohotelScreen extends StatefulWidget {
  @override
  _TagmoohotelScreenState createState() => _TagmoohotelScreenState();
}

class _TagmoohotelScreenState extends State<TagmoohotelScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? hotelData;
  String? errorMessage;

  final List<Map<String, dynamic>> hotels = [
    {
      "name": "الشاليه",
      "photos": [
        "assets/images/lvndolashalih1.jpg",
        "assets/images/lvndolashalih2.jpg",
        "assets/images/lvndolashalih3.jpg",
        "assets/images/lvndolashalih4.jpg",
        "assets/images/lvndolashalih5.jpg",
        "assets/images/lvndolashalih6.jpg",
      ],
    },
    {
      "name": "السويت العائلي",
      "photos": [
        "assets/images/lvndolaroom1.jpg",
        "assets/images/lvndolaroom2.jpg",
        "assets/images/lvndolaroom3.jpg",
        "assets/images/lvndolaroom4.jpg",
      ],
    },
    {
      "name": "السويت الفاخر",
      "photos": [
        "assets/images/lvndolasweet1.jpg",
        "assets/images/lvndolasweet2.jpg",
        "assets/images/lvndolasweet3.jpg",
        "assets/images/lvndolasweet4.jpg",
      ],
    },
    {
      "name": "الغرف",
      "photos": [
        "assets/images/lvndolaroom1.jpg",
        "assets/images/lvndolaroom2.jpg",
        "assets/images/lvndolaroom3.jpg",
        "assets/images/lvndolaroom4.jpg",
      ],
    }
  ];

  final List<Map<String, dynamic>> newhotels = [
    {
      "name": "الشاليه",
      "photos": [
        "assets/images/shalih1.jpg",
        "assets/images/shalih2.jpg",
        "assets/images/shalih3.jpg",
        "assets/images/shalih4.jpeg",
      ],
    },
    {
      "name": "السويت العائلي",
      "photos": [
        "assets/images/plazaroom1.jpg",
        "assets/images/plazaroom2.jpg",
        "assets/images/plazaroom3.jpg",
        "assets/images/plazaroom4.jpg",
        "assets/images/plazaroom5.jpg",
      ],
    },
    {
      "name": "السويت الفاخر",
      "photos": [
        "assets/images/sweet1.jpg",
        "assets/images/sweet2.jpg",
        "assets/images/sweet3.jpg",
        "assets/images/sweet5.jpg",
      ],
    },
    {
      "name": "الغرف",
      "photos": [
        "assets/images/plazaroom1.jpg",
        "assets/images/plazaroom2.jpg",
        "assets/images/plazaroom3.jpg",
        "assets/images/plazaroom4.jpg",
        "assets/images/plazaroom5.jpg",
      ],
    }
  ];

  @override
  void initState() {
    super.initState();
    _fetchHotelData();
  }

  Future<void> _fetchHotelData() async {
    try {
      final response = await supabase
          .from('eltgmoohotel_links')
          .select('phone1, phone2, price_plaza, price_lavendola, location_plaza, location_lavendola')
          .eq('id', '1')
          .maybeSingle(); // Use maybeSingle to handle no results gracefully

      if (response == null) {
        throw Exception('No data found for id = 1');
      }

      setState(() {
        hotelData = response;
        print('Fetched data: $hotelData'); // Debug print
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'فشل في جلب البيانات من Supabase. يتم استخدام البيانات الافتراضية.';
        hotelData = {
          'phone1': '0224481217',
          'phone2': '0224481218',
          'price_plaza': 'https://i.imghippo.com/files/pef4882xow.jpg',
          'price_lavendola': 'https://i.imghippo.com/files/pef4882xow.jpg',
          'location_plaza': 'https://maps.app.goo.gl/jQ3sngisWynZTzWj6',
          'location_lavendola': 'https://maps.app.goo.gl/2vmCBmTYYyfG6iaWA',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),
        fontFamily: 'Cairo',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "الفنادق والمنتجعات",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: hotelData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: GoogleFonts.cairo(color: Colors.red),
                ),
              ),
            Expanded(
              child: DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blue,
                      labelStyle: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: "فندق لافندولا"),
                        Tab(text: "فندق تيباروز بلازا"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildHotelCategory(context),
                          _buildnewCategory(context),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showPriceImage(context, hotelData!['price_plaza']),
                            icon: const Icon(Icons.price_check),
                            label: Text("أسعار فندق تيباروز بلازا",
                                style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showPriceImage(context, hotelData!['price_lavendola']),
                            icon: const Icon(Icons.price_check),
                            label: Text("أسعار فندق لافندولا",
                                style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(hotelData!['location_lavendola']),
                            icon: const Icon(Icons.location_on),
                            label: Text("موقع فندق لافندولا",
                                style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(hotelData!['location_plaza']),
                            icon: const Icon(Icons.location_on),
                            label: Text("موقع فندق تيباروز بلازا",
                                style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showPhoneDialog(context),
                            icon: const Icon(Icons.phone),
                            label: Text("التواصل هاتفياً",
                                style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceImage(BuildContext context, String imageUrl) async {
    // Validate URL before navigating
    if (await canLaunch(imageUrl)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                'فشل في تحميل الصورة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يمكن فتح رابط الأسعار',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختار رقم للاتصال",
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "رقم 1: ${hotelData!['phone1']}",
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl("tel:${hotelData!['phone1']}");
                  },
                ),
                ListTile(
                  title: Text(
                    "رقم 2: ${hotelData!['phone2']}",
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl("tel:${hotelData!['phone2']}");
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء", style: GoogleFonts.cairo()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHotelCategory(BuildContext context) {
    return DefaultTabController(
      length: hotels.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            labelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            unselectedLabelColor: Colors.grey,
            tabs: hotels.map((hotel) => Tab(text: hotel["name"])).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: hotels.map((hotel) => _buildHotelDetails(context, hotel)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildnewCategory(BuildContext context) {
    return DefaultTabController(
      length: newhotels.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            labelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            unselectedLabelColor: Colors.grey,
            tabs: newhotels.map((hotel) => Tab(text: hotel["name"])).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: newhotels.map((hotel) => _buildHotelDetails(context, hotel)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelDetails(BuildContext context, Map<String, dynamic> hotel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              hotel["name"],
              style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              items: hotel["photos"].map<Widget>((photo) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoView(
                          imageProvider: AssetImage(photo),
                          backgroundDecoration: const BoxDecoration(color: Colors.black),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      photo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'لا يمكن فتح الرابط: $url',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ أثناء فتح الرابط: $e',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}