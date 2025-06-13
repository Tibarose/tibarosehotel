import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlnozhahotelScreen extends StatefulWidget {
  const AlnozhahotelScreen({super.key});

  @override
  _AlnozhahotelScreenState createState() => _AlnozhahotelScreenState();
}

class _AlnozhahotelScreenState extends State<AlnozhahotelScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? hoteltibaData;
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
      "photos": ["assets/images/t2.jpg",
        "assets/images/t3.jpg",
        "assets/images/grandhotel1.jpg",
        "assets/images/grandhotel.jpg",

      ],
    }
  ];

  final List<Map<String, dynamic>> newhotels = [
    {
      "name": "الشاليه",
      "photos": [
        "assets/images/tibarose3.jpg",
        "assets/images/tibarose4.jpg",
        "assets/images/tibarose5.jpg",
        "assets/images/tibarose6.jpg",
        "assets/images/tibarose7.jpg",
        "assets/images/tibarose8.jpg",
        "assets/images/tibarose9.jpg",
        "assets/images/tibarose10.jpg",
        "assets/images/tibarose11.jpg",
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
          .from('alnozhahotel_links')
          .select('tibarose_price, grandtibarose_price, tibarose_location, grandtibarose_location, phone1, phone2')
          .eq('id', '1')
          .maybeSingle();

      if (response == null) {
        throw Exception('No data found for id = 1');
      }

      setState(() {
        hoteltibaData = response;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'فشل في جلب البيانات من Supabase. يتم استخدام البيانات الافتراضية.';
        hoteltibaData = {
          'tibarose_price': 'https://i.imghippo.com/files/pef4882xow.jpg',
          'grandtibarose_price': 'https://i.imghippo.com/files/pef4882xow.jpg',
          'tibarose_location': 'https://maps.app.goo.gl/FBCEwWpnZbBCVNHK9',
          'grandtibarose_location': 'https://maps.app.goo.gl/PJQbEtLm3nmYnntR6',
          'phone1': '0224481217',
          'phone2': '0224481218',
        };
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'لا يمكن فتح الرابط: $url',
              style: GoogleFonts.cairo(fontSize: 14),
            ),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ أثناء فتح الرابط: $e',
            style: GoogleFonts.cairo(fontSize: 14),
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  void _showPriceImage(BuildContext context, String imageUrl, String hotelName) {
    if (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'رابط الصورة غير صالح',
            style: GoogleFonts.cairo(fontSize: 14),
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "أسعار $hotelName",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained * 0.7,
                maxScale: PhotoViewComputedScale.covered * 3.5,
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
                enableRotation: false,
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    'فشل تحميل الصورة',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إغلاق",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 8,
        );
      },
    );
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختار رقم للاتصال",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "رقم 1: ${hoteltibaData?['phone1'] ?? 'غير متوفر'}",
                    style: GoogleFonts.cairo(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  onTap: hoteltibaData?['phone1'] != null
                      ? () {
                    Navigator.pop(context);
                    _launchUrl("tel:${hoteltibaData!['phone1']}");
                  }
                      : null,
                ),
                ListTile(
                  title: Text(
                    "رقم 2: ${hoteltibaData?['phone2'] ?? 'غير متوفر'}",
                    style: GoogleFonts.cairo(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  onTap: hoteltibaData?['phone2'] != null
                      ? () {
                    Navigator.pop(context);
                    _launchUrl("tel:${hoteltibaData!['phone2']}");
                  }
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الفنادق",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: hoteltibaData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            Expanded(
              child: DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blue.shade700,
                      labelColor: Colors.blue.shade700,
                      unselectedLabelColor: Colors.grey.shade600,
                      labelStyle: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: GoogleFonts.cairo(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: "فندق جراند تيباروز"),
                        Tab(text: "فندق تيباروز"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildHotelCategory(context),
                          _buildNewCategory(context),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showPriceImage(context, hoteltibaData!['tibarose_price'], "فندق تيباروز"),
                            icon: const Icon(Icons.price_check, color: Colors.white),
                            label: Text(
                              "أسعار فندق تيباروز",
                              style: GoogleFonts.cairo(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showPriceImage(context, hoteltibaData!['grandtibarose_price'], "فندق جراند تيباروز"),
                            icon: const Icon(Icons.price_check, color: Colors.white),
                            label: Text(
                              "أسعار فندق جراند تيباروز",
                              style: GoogleFonts.cairo(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(hoteltibaData!['tibarose_location']),
                            icon: const Icon(Icons.location_on, color: Colors.white),
                            label: Text(
                              "موقع فندق تيباروز",
                              style: GoogleFonts.cairo(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(hoteltibaData!['grandtibarose_location']),
                            icon: const Icon(Icons.location_on, color: Colors.white),
                            label: Text(
                              "موقع فندق جراند تيباروز",
                              style: GoogleFonts.cairo(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showPhoneDialog(context),
                            icon: const Icon(Icons.phone, color: Colors.white),
                            label: Text(
                              "التواصل هاتفياً",
                              style: GoogleFonts.cairo(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
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

  Widget _buildHotelCategory(BuildContext context) {
    return DefaultTabController(
      length: hotels.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue.shade700,
            labelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              fontSize: 14,
            ),
            unselectedLabelColor: Colors.grey.shade600,
            unselectedLabelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
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

  Widget _buildNewCategory(BuildContext context) {
    return DefaultTabController(
      length: newhotels.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue.shade700,
            labelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              fontSize: 14,
            ),
            unselectedLabelColor: Colors.grey.shade600,
            unselectedLabelStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
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
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              items: hotel["photos"].map<Widget>((photo) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: PhotoView(
                                imageProvider: AssetImage(photo),
                                minScale: PhotoViewComputedScale.contained * 0.7,
                                maxScale: PhotoViewComputedScale.covered * 3.5,
                                initialScale: PhotoViewComputedScale.contained,
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                enableRotation: false,
                                loadingBuilder: (context, event) => const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                ),
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Text(
                                    'فشل تحميل الصورة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                                heroAttributes: PhotoViewHeroAttributes(tag: photo),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "إغلاق",
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 8,
                        );
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      photo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}