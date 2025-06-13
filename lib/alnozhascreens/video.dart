import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SwimmingPoolsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pools = [
    {
      "name": "حمام سباحه تيباروز (اوليمبى)",
      "photos": [
        "assets/images/swimmingtibarose1.jpg",
        "assets/images/swimmingtibarose.jpg",
      ],
      "dimensions": "12.50م × 25م",
      "depth": "1م - 4م",
      "details": "هذا المسبح الأولمبي مثالي للتدريب المهني والمنافسات.",
      "location": "https://maps.app.goo.gl/Pjz2XCSy8mHn5gpL7",
      "priceImage": "https://i.imghippo.com/files/bfH5413qs.jpg", // Add the price image URL
    },
    {
      "name": "حمام سباحه جراند تيباروز",
      "photos": [
        "assets/images/grand1.jpg",
        "assets/images/grand2.jpg",
      ],
      "dimensions": "11م × 17م",
      "depth": "1.40م",
      "details": "مسبح آمن وممتع للأطفال، مزود بألعاب مائية وزحاليق.",
      "location": "https://maps.app.goo.gl/V4DCVH5AWimjZTE39",
      "priceImage": "https://i.imghippo.com/files/kMvP2562lSY.jpg", // Add the price image URL
    },
    {
      "name": "حمام سباحه باراديس",
      "photos": [
        "assets/images/paradise1.jpg",
        "assets/images/paradise2.jpg",
        "assets/images/paradise3.jpg",
        "assets/images/paradise.jpg",

      ],
      "dimensions": "9م × 11م",
      "depth": "1.60م - 1.80م",
      "details": "مسبح هادئ للاسترخاء والراحة، محاط بالخضرة.",
      "location": "https://maps.app.goo.gl/gx8Qt2no2ChGSk5A6",
      "priceImage": "https://i.imghippo.com/files/Yo6167j.jpg", // Add the price image URL
    },
    {
      "name": "حمام سباحه تيباروز بيضاوي",
      "photos": [
        "assets/images/swimmingtibarose1.jpg",
        "assets/images/swimmingtibarose.jpg",
      ],
      "dimensions": "بيضاوي",
      "depth": "1.60م - 6م",
      "details": "مسبح هادئ للاسترخاء والراحة، محاط بالخضرة.",
      "location": "https://maps.app.goo.gl/vaUFzbVMerPjDuyZ9",
      "priceImage": "https://i.imghippo.com/files/yT7371OmY.jpg", // Add the price image URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Change to RTL for Arabic
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "السباحه",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _buildPoolsTab(context),
      ),
    );
  }

  Widget _buildPoolsTab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(pools.length, (index) {
              final pool = pools[index];
              return Card(
                elevation: 12,
                margin: EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        CarouselSlider(
                          items: pool["photos"].map<Widget>((photo) {
                            return ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pool["name"],
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Row 1 - Dimensions & Depth
                          Row(
                            children: [
                              // Dimensions Box
                              Expanded(
                                child: _buildSectionBox(
                                  title: "الأبعاد",
                                  content: Text(
                                    pool["dimensions"],
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Depth Box
                              Expanded(
                                child: _buildSectionBox(
                                  title: "العمق",
                                  content: Text(
                                    pool["depth"],
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Row 2 - Prices & Location
                          Row(
                            children: [
                              // Prices Box
                              Expanded(
                                child: _buildSectionBox(
                                  title: "الأسعار",
                                  content: InkWell(
                                    onTap: () {
                                      _showPricePopup(context, pool["priceImage"]);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "عرض الأسعار",
                                          style: GoogleFonts.cairo(
                                            fontSize: 14,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Icon(Icons.info_outline, color: Colors.blue),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Location Box
                              Expanded(
                                child: _buildSectionBox(
                                  title: "الموقع",
                                  content: InkWell(
                                    onTap: () async {
                                      final url = pool["location"];
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not open $url';
                                      }
                                    },
                                    child: Text(
                                      "عرض الموقع على الخريطة",
                                      style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Helper method to create each box section
  Widget _buildSectionBox({
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  // Show the price popup
  void _showPricePopup(BuildContext context, String priceImageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'أسعار المسبح',
            style: GoogleFonts.cairo(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity, // Make the container take full width
                height: 350, // Adjust the height as needed
                child: Image.network(
                  priceImageUrl,
                  fit: BoxFit.contain, // You can use BoxFit.cover to fill the container or BoxFit.fitWidth
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              child: Text('إغلاق', style: GoogleFonts.cairo()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
