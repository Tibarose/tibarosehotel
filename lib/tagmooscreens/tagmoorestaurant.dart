import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class tagmooRestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<tagmooRestaurantsScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "مطعم بيونيا",
      "photos": [
        "assets/images/b1.jpg",
        "assets/images/b2.jpg",
        "assets/images/b3.jpg",
        "assets/images/b4.jpg",
        "assets/images/b5.jpg",
        "assets/images/b6.jpg",
      ],
      "location": "https://maps.app.goo.gl/F1Rkr7gkYJeQyHLu7",
      "menu": "https://drive.google.com/file/d/1P558uujGOVvgvRJFatVLbNOXLY6lYHWE/view?usp=sharing",
      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": " طوال اليوم ",
    },
    {
      "name": "Marvel",
      "photos": [
        "assets/images/m1.jpg",
        "assets/images/m2.jpg",
      ],
      "location": "https://maps.app.goo.gl/cqmWb8cHBf5LmVvC9",
      "menu": "https://drive.google.com/file/d/1R1punNAzD6VTkRdrW5Y1Tz1b8O_NyCjp/view?usp=sharing",
      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
    {
      "name": "مطعم جاردينيا",
      "photos": [
        "assets/images/g1.jpg",
        "assets/images/g2.jpg",
        "assets/images/g4.jpg",
        "assets/images/3.jpg",
        "assets/images/g5.jpg",
      ],
      "location": "https://maps.app.goo.gl/mxvC3czoMHXXhbJG9",
      "menu": "https://drive.google.com/file/d/1P558uujGOVvgvRJFatVLbNOXLY6lYHWE/view?usp=sharing",
      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": " طوال اليوم ",
    },
    {
      "name": "Garden",
      "photos": [
        "assets/images/garden1.jpg",
        // "assets/images/garden2.jpg",
        "assets/images/garden3.jpg",

      ],
      "location": "https://maps.app.goo.gl/eCgzDbzgVrq1eRUo8",
      "menu": "https://drive.google.com/file/d/1fYtLO5sS5iuhQ5pp5v9oAyVVyXAtussq/view?usp=sharing",
      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    }, {
      "name": "مطعم السفينه",
      "photos": [
        "assets/images/safina.jpg",
        "assets/images/safina1.jpg",
        "assets/images/safina2.jpg",

      ],
      "location": "https://maps.app.goo.gl/1ghpJ8hdUYzGyVXv5",
      "menu": "https://drive.google.com/file/d/1177R0lGCVtbyYh-Oju-64cRiGxxw0A_w/view?usp=drivesdk",

      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },{
      "name": "التيك اوي",
      "photos": [
        "assets/images/take.jpg",
        "assets/images/take1.jpg",
        "assets/images/take2.jpg",
        "assets/images/take3.jpg",

      ],
      "location": "https://maps.app.goo.gl/eCgzDbzgVrq1eRUo8",
      "menu": "https://drive.google.com/file/d/1U02hAUDhpEEKehsLZNupLzR5v5lZRore/view?usp=drivesdk",
      "prices": "https://docs.google.com/forms/d/e/1FAIpQLSdsIfUW3TR2H-qDSgDjEQVgOjzE3XmXsYYkektnP5vkhLAM-g/viewform",
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showPriceDialog(BuildContext context, String price, String priceImage) {
    // You can implement your dialog for showing prices here
  }

  @override
  Widget build(BuildContext context) {
    return


      Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "المطاعم",
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
          body: Column(
            children: [
              // Ramadan Menu Button at the Top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _launchURL("https://drive.google.com/file/d/19_pMTDuHhqiZy9EqyGQv_vjtJpon0XES/view");
                    },
                    icon: Icon(Icons.restaurant_menu, color: Colors.black),
                    label: Center(
                      child: Text(
                        " اضغط هنا للاطلاع على منيو الافطار والسحور فى رمضان",
                        style: GoogleFonts.cairo(
                          color: Colors.black,

                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),textAlign: TextAlign.center,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),

              Expanded(child: _buildFoodTab()),
            ],
          ),
        ),
      );
  }

  Widget _buildFoodTab() {
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
            children: [
              // Restaurant Listings
              ...List.generate(restaurants.length, (index) {
                final restaurant = restaurants[index];
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
                            items: restaurant["photos"].map<Widget>((photo) {
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
                                restaurant["name"],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  restaurant["openTime"],
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _launchURL(restaurant["menu"]);
                                    },
                                    icon: Icon(Icons.menu_book, color: Colors.black),
                                    label: Text(
                                      "Menu قائمه الطعام",
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Full-width button for Prices
                                // Full-width button for Location
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _launchURL(restaurant["location"]);
                                    },
                                    icon: Icon(Icons.location_on, color: Colors.black),
                                    label: Text(
                                      "موقع المطعم",
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Full-width button for Menu
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _launchURL(restaurant["prices"]);
                                    },
                                    icon: Icon(Icons.add, color: Colors.black),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
