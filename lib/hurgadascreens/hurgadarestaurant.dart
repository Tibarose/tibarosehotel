import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class HurgadarestaurantScreen extends StatelessWidget {
  final Map<String, dynamic> activity = {
    "name": "المطعم",
    "photos": [
      "https://i.postimg.cc/8PjxTc9C/Whats-App-Image-2025-03-13-at-13-09-50-c3de6441.jpg",
      "https://i.postimg.cc/cHx52Lf0/Whats-App-Image-2025-03-13-at-13-09-50-6de2fe13.jpg",
      "https://i.postimg.cc/gkXtf5LX/Whats-App-Image-2025-03-13-at-12-35-34-dc0d95b8.jpg",
      "https://i.postimg.cc/mDg8V6Gr/Whats-App-Image-2025-03-13-at-12-39-48-cc889182.jpg",
    ],
    "location": "https://maps.app.goo.gl/PJQbEtLm3nmYnntR6",
    "booking": "https://docs.google.com/forms/d/e/1FAIpQLSfKqb_MrZ8dAT9yhEBETBWLIz2uwOcijZrBXe8EaUUlFiwgrg/viewform",
    "priceImage": "https://i.imghippo.com/files/OB6246xs.png",
  };

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showPriceDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "الأسعار",
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 300,
            width: 300,
            child: PhotoView(
              imageProvider: NetworkImage(imagePath),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("إغلاق", style: GoogleFonts.cairo(fontSize: 14)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المطعم",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildActivitySection(context),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [

                    CarouselSlider(
                      items: activity["photos"].map<Widget>((photo) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(photo, fit: BoxFit.cover, width: double.infinity),
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
                          onPressed: () => _showPriceDialog(context, activity["priceImage"]),
                          icon: Icon(Icons.payment, color: Colors.black),
                          label: Text("الأسعار", style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),

                      ],
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
}
