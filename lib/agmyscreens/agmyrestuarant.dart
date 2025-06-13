import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class AgmyrestuarantScreen extends StatefulWidget {
  @override
  _AgmyHotelScreenState createState() => _AgmyHotelScreenState();
}

class _AgmyHotelScreenState extends State<AgmyrestuarantScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "المطعم الرئيسى",
      "photos": [
        "https://i.imghippo.com/files/uult1114Kn.jpg",
        "https://i.imghippo.com/files/mr2018zS.jpg",
        "https://i.imghippo.com/files/Bil7886v.jpg",
        "https://i.imghippo.com/files/sdu9668qmU.jpg",

      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/Yac4148oqA.jpg",
    },
    {
      "name": "الحلوانى",
      "photos": [
        "https://i.imghippo.com/files/htx2456Fo.jpg",
        "https://i.imghippo.com/files/EO1411Us.jpg",
        "https://i.imghippo.com/files/GEqt1515eE.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/sUr2496yzw.jpg",
    },
    {
      "name": "كافتيريا التراس",
      "photos": [
        "https://i.imghippo.com/files/OUS1224Tww.jpg",
        "https://i.imghippo.com/files/aky5149kbw.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/mcp9644aK.jpg",
    },
    {
      "name": "كافتيريا الروف",
      "photos": [
        "https://i.imghippo.com/files/vSF1019ssk.jpg",
        "https://i.imghippo.com/files/CaXC4398pgw.jpg",
        "https://i.imghippo.com/files/MgcA6478oXs.jpg",
      ],
      "location": "https://maps.app.goo.gl/mFoWWTHC6AbeKXVK7",
      "prices": "https://i.imghippo.com/files/mcp9644aK.jpg",
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
            "المطاعم",
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
