import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class AgmyHotelScreen extends StatefulWidget {
  @override
  _AgmyHotelScreenState createState() => _AgmyHotelScreenState();
}

class _AgmyHotelScreenState extends State<AgmyHotelScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "الغرف الفندقية",
      "photos": [
        "https://i.imghippo.com/files/pef4882xow.jpg",
        "https://i.imghippo.com/files/MGX9377wUE.jpg",
        "https://i.imghippo.com/files/MNe7298PDY.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/msP1628FG.png",
    },
    {
      "name": "الجناح الفاخر",
      "photos": [
        "https://i.imghippo.com/files/EcOb3087L.jpg",
        "https://i.imghippo.com/files/Aqk8433jk.jpg",
        "https://i.imghippo.com/files/Pym4736CP.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/msP1628FG.png",
    },
    {
      "name": "الجناح العائلي",
      "photos": [
        "https://i.imghippo.com/files/TE2053Ng.jpg",
        "https://i.imghippo.com/files/CJ6063gGA.jpg",
        "https://i.imghippo.com/files/HB3225no.jpg",
        "https://i.imghippo.com/files/mf5923Wvg.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/msP1628FG.png",
    },
    {
      "name": "الجناح الملكى",
      "photos": [
        "https://i.imghippo.com/files/LNd6223qX.jpg",
        "https://i.imghippo.com/files/gxZ8595lOw.jpg",
        "https://i.imghippo.com/files/IQbW2203YM.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/msP1628FG.png",
    },
  ];

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'تعذر فتح الرابط: $url';
    }
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InteractiveViewer(
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الفندق",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 30,
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
        body: _buildHotelContent(),
      ),
    );
  }

  Widget _buildHotelContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: restaurants.map((hotel) => _buildHotelCard(hotel)).toList(),
        ),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
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
                items: hotel["photos"].map<Widget>((photoUrl) {
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      photoUrl,
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hotel["name"],
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.amberAccent,
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
                _buildButton("الاسعار", Icons.menu_book, hotel["prices"]),
                SizedBox(height: 8),
                _buildButton("الموقع", Icons.location_on, hotel["location"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, String url) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (url.endsWith(".jpg") || url.endsWith(".png") || url.endsWith(".jpeg")) {
            _showImageDialog(url);
          } else {
            _launchURL(url);
          }
        },
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
