import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class TagmoohotelScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(),
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
        body: Column(
          children: [
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoView(
                                    imageProvider: const NetworkImage(
                                      "https://i.imghippo.com/files/wkm8142JDU.jpg",
                                    ),
                                    backgroundDecoration: const BoxDecoration(color: Colors.black),
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale: PhotoViewComputedScale.covered * 2,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.price_check),
                            label: Text("أسعار فندق تيباروز بلازا", style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoView(
                                    imageProvider: const NetworkImage(
                                      "https://i.imghippo.com/files/wkm8142JDU.jpg",
                                    ),
                                    backgroundDecoration: const BoxDecoration(color: Colors.black),
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale: PhotoViewComputedScale.covered * 2,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.price_check),
                            label: Text("أسعار فندق لافندولا", style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(hotels[0]["location"]),
                            icon: const Icon(Icons.location_on),
                            label: Text("موقع فندق لافندولا", style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(newhotels[0]["location"]),
                            icon: const Icon(Icons.location_on),
                            label: Text("موقع فندق تيباروز بلازا", style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showPhoneDialog(context),
                            icon: const Icon(Icons.phone),
                            label: Text("التواصل هاتفياً", style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            height: 200,
            child: ListView.builder(
              itemCount: hotels.length + newhotels.length, // Include both hotels and newhotels
              itemBuilder: (context, index) {
                final isHotel = index < hotels.length;
                final phone = isHotel
                    ? hotels[index]["phone"]
                    : newhotels[index - hotels.length]["phone"];
                final name = isHotel
                    ? hotels[index]["name"]
                    : newhotels[index - hotels.length]["name"];
                return ListTile(
                  title: Text(
                    "$name: $phone",
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl("tel:$phone");
                  },
                );
              },
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
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        debugPrint('لا يمكن فتح الرابط: $url');
      }
    } catch (e) {
      debugPrint('خطأ أثناء فتح الرابط: $e');
    }
  }
}