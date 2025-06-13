import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class HurgadaHotelScreen extends StatefulWidget {
  @override
  _AgmyHotelScreenState createState() => _AgmyHotelScreenState();
}

class _AgmyHotelScreenState extends State<HurgadaHotelScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Singel   سنجل",
      "photos": [
        "https://i.imghippo.com/files/njx6161aN.jpg",
        "https://i.imghippo.com/files/voY5557oP.jpg",
        "https://i.imghippo.com/files/yH9683M.jpg",
      ],
      "location": "https://maps.app.goo.gl/ET2jK8DGpwYbaVm16",
      "prices": "https://i.postimg.cc/W4r9hJw2/16-x-11-cm-10-5-x-14-8-cm-21-x-35-cm.png",
    },
    {
      "name": "Double   دابل",
      "photos": [
        "https://i.imghippo.com/files/HrL9037ITI.jpg",
        "https://i.imghippo.com/files/yH9683M.jpg",
        "https://i.imghippo.com/files/Ekl1307pro.jpg",
      ],
      "location": "https://maps.app.goo.gl/ET2jK8DGpwYbaVm16",
      "prices": "https://i.postimg.cc/W4r9hJw2/16-x-11-cm-10-5-x-14-8-cm-21-x-35-cm.png",
    },
    {
      "name": "Trible     تريبل",
      "photos": [
        "https://i.imghippo.com/files/ccb8086mVU.jpg",
        "https://i.imghippo.com/files/xkOn9998zqM.jpg",
        "https://i.imghippo.com/files/iMLB1082Pg.jpg",
      ],
      "location": "https://maps.app.goo.gl/ET2jK8DGpwYbaVm16",
      "prices": "https://i.postimg.cc/W4r9hJw2/16-x-11-cm-10-5-x-14-8-cm-21-x-35-cm.png",
    },
    {
      "name": "Sweet    سويت",
      "photos": [
        "https://i.imghippo.com/files/kI6313UYk.jpg",
        "https://i.imghippo.com/files/WSom7672mOY.jpg",
        "https://i.imghippo.com/files/PxU3522QL.jpg",
      ],
      "location": "https://maps.app.goo.gl/ET2jK8DGpwYbaVm16",
      "prices": "https://i.postimg.cc/W4r9hJw2/16-x-11-cm-10-5-x-14-8-cm-21-x-35-cm.png",
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
            icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
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
