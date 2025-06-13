import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class HotelsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> hotels = [
    {
      "name": "فندق جراند تيباروز",
      "photos": [
        "assets/images/t2.jpg",
        "assets/images/t3.jpg",
        "assets/images/grandhotel1.jpg",
        "assets/images/grandhotel.jpg",
      ],
      "location": "https://maps.app.goo.gl/PJQbEtLm3nmYnntR6",
      "booking": "https://docs.google.com/forms/d/e/1FAIpQLSfKqb_MrZ8dAT9yhEBETBWLIz2uwOcijZrBXe8EaUUlFiwgrg/viewform",
      "price": "150 USD",
      "priceImage": "assets/images/grandtibaprice.png",
    },
    {
      "name": "فندق تيباروز",
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
      "location": "https://maps.app.goo.gl/FBCEwWpnZbBCVNHK9",
      "booking": "https://docs.google.com/forms/d/e/1FAIpQLSfKqb_MrZ8dAT9yhEBETBWLIz2uwOcijZrBXe8EaUUlFiwgrg/viewform",
      "price": "200 USD",
      "priceImage": "assets/images/tibaroseprice.png",
    },
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showPriceDialog(BuildContext context, String price, String imagePath, String bookingUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "الأسعار - $price",
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
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 3.0, // زيادة الحد الأقصى للزوم
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                enableRotation: false, // تعطيل التدوير لتحسين تجربة المستخدم
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _launchURL(bookingUrl);
              },
              child: Text(
                "حجز الآن",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              indicatorColor: Colors.blue,
              labelStyle: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  text: "فندق جراند تيباروز",
                  icon: Icon(Icons.hotel),
                ),
                Tab(
                  text: "فندق تيباروز",
                  icon: Icon(Icons.hotel),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildHotelTab(0, context),
              _buildHotelTab(1, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelTab(int index, BuildContext context) {
    final hotel = hotels[index];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 6,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          hotel["name"],
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        CarouselSlider(
                          items: hotel["photos"].map<Widget>((photo) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            aspectRatio: 16 / 9,
                            enableInfiniteScroll: true,
                            autoPlayInterval: Duration(seconds: 3),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showPriceDialog(
                                  context,
                                  hotel["price"],
                                  hotel["priceImage"],
                                  hotel["booking"],
                                );
                              },
                              icon: Icon(Icons.payment, color: Colors.black),
                              label: Text(
                                "الأسعار",
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                _launchURL(hotel["location"]);
                              },
                              icon: Icon(Icons.location_on, color: Colors.black),
                              label: Text(
                                "موقع الفندق",
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                _launchURL(hotel["booking"]);
                              },
                              icon: Icon(Icons.book_online, color: Colors.black),
                              label: Text(
                                "طلب حجز",
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}