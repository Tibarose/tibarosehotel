import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CelebrationsScreen extends StatefulWidget {
  @override
  _CelebrationsScreenState createState() => _CelebrationsScreenState();
}

class _CelebrationsScreenState extends State<CelebrationsScreen> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;
  String? errorMessage;

  final SupabaseClient supabase = Supabase.instance.client;

  // Local data for photos, openTime, location, and displayName (since they are not in the database)
  final Map<String, Map<String, dynamic>> localData = {
    "gardenvip": {
      "displayName": "Garden Vip", // Renamed for display
      "photos": [
        "assets/images/gardenvip.jpg",
        "assets/images/gardenvip4.jpg",
        "assets/images/gardenvip2.jpg",
        "assets/images/gardenvip3.jpg",
      ],
      "openTime": "طوال اليوم",
      "location": "https://maps.app.goo.gl/2MoTM1gGVwdYi2Nd9",
    },
    "banciarestaurant": {
      "displayName": "مطعم وصالون البانسية", // Renamed for display
      "photos": [
        "assets/images/bansss1.jpg",
        "assets/images/bansss2.jpg",
        "assets/images/bansss3.jpg",
        "assets/images/bansss4.jpg",
        "assets/images/bansss5.jpg",
      ],
      "openTime": "طوال اليوم",
      "location": "https://maps.app.goo.gl/yJ6zNHkCUGNQMt8x7",
    },
    "viphall": {
      "displayName": "Grand Tibarose Vip Hall", // Renamed for display
      "photos": [
        "assets/images/vippp1.jpg",
        "assets/images/vippp2.jpg",
        "assets/images/vippp3.jpg",
        "assets/images/vippp4.jpg",
      ],
      "openTime": "طوال اليوم",
      "location": "https://maps.app.goo.gl/yJ6zNHkCUGNQMt8x7",
    },
  };

  @override
  void initState() {
    super.initState();
    fetchRestaurantsData();
  }

  Future<void> fetchRestaurantsData() async {
    try {
      final response = await supabase
          .from('haflat')
          .select('name, menu, contact')
          .order('id', ascending: true); // Order by id to match table order

      setState(() {
        restaurants = (response as List<dynamic>).map<Map<String, dynamic>>((item) {
          final local = localData[item['name']] ?? {};
          return {
            "name": item['name'], // Keep Supabase name for internal use
            "displayName": local['displayName'] ?? item['name'], // Use displayName or fallback to Supabase name
            "photos": local['photos'] ?? [],
            "openTime": local['openTime'] ?? 'غير متوفر',
            "location": local['location'] ?? '',
            "menu": item['menu'],
            "contact": item['contact'],
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching haflat data: $e');
      setState(() {
        errorMessage = 'فشل في جلب بيانات الحفلات من Supabase.';
        isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "حفلات وتسويق",
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
          child: Text(
            errorMessage!,
            style: GoogleFonts.cairo(color: Colors.red),
          ),
        )
            : _buildFoodTab(),
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
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    );
                                  },
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
                                restaurant["displayName"], // Use displayName instead of name
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
                                      "قائمه الطعام",
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
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _launchURL(restaurant["location"]);
                                    },
                                    icon: Icon(Icons.location_on, color: Colors.black),
                                    label: Text(
                                      "الموقع",
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
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _launchURL(restaurant["contact"]);
                                    },
                                    icon: Icon(Icons.phone, color: Colors.black),
                                    label: Text(
                                      "التواصل",
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