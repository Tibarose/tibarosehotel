import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> restaurantData = [];
  String? errorMessage;

  final List<Map<String, dynamic>> restaurants = [
    {
      "id": "1",
      "name": "مطعم بيونيا", // Local name (Arabic)
      "photos": [
        "assets/images/b1.jpg",
        "assets/images/b2.jpg",
        "assets/images/b3.jpg",
        "assets/images/b4.jpg",
        "assets/images/b5.jpg",
        "assets/images/b6.jpg",
      ],
      "openTime": "طوال اليوم",
    },
    {
      "id": "2",
      "name": "Marvel", // Matches Supabase
      "photos": [
        "assets/images/m1.jpg",
        "assets/images/m2.jpg",
      ],
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
    {
      "id": "3",
      "name": "مطعم جاردينيا", // Local name (Arabic)
      "photos": [
        "assets/images/g1.jpg",
        "assets/images/g2.jpg",
        "assets/images/g4.jpg",
        "assets/images/3.jpg",
        "assets/images/g5.jpg",
      ],
      "openTime": "طوال اليوم",
    },
    {
      "id": "4",
      "name": "Garden", // Matches Supabase
      "photos": [
        "assets/images/garden1.jpg",
        "assets/images/garden3.jpg",
      ],
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
    {
      "id": "5",
      "name": "مطعم السفينه", // Local name (Arabic)
      "photos": [
        "assets/images/safina.jpg",
        "assets/images/safina1.jpg",
        "assets/images/safina2.jpg",
      ],
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
    {
      "id": "6",
      "name": "التيك اوي", // Local name (Arabic)
      "photos": [
        "assets/images/take.jpg",
        "assets/images/take1.jpg",
        "assets/images/take2.jpg",
        "assets/images/take3.jpg",
      ],
      "openTime": "من الساعه 10 صباحا الى 12 صباحا",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData();
  }

  Future<void> _fetchRestaurantData() async {
    try {
      final response = await supabase
          .from('alnozharestaurant_links')
          .select('id, الاسم, المنيو, الموقع, التواصل')
          .order('id', ascending: true);

      if (response.isEmpty) {
        throw Exception('No restaurant data found');
      }

      setState(() {
        restaurantData = List<Map<String, dynamic>>.from(response);
        print('Fetched restaurant data: $restaurantData');
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'فشل في جلب بيانات المطاعم من Supabase.';
        restaurantData = [
          {
            'id': '1',
            'الاسم': 'بيونيا',
            'المنيو': 'https://github.com/mahmoudnazmy103103/TRH/raw/main/general/WhatsApp%20Image%202025-02-05%20at%2023.08.37_3dba6452.jpg',
            'الموقع': 'https://maps.app.goo.gl/F1Rkr7gkYJeQyHLu7',
            'التواصل': 'tel:0123456789',
          },
        ];
      });
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يمكن فتح الرابط: $url', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ أثناء فتح الرابط: $e', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
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
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: restaurantData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: GoogleFonts.cairo(color: Colors.red),
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
              ...List.generate(restaurants.length, (index) {
                final localRestaurant = restaurants[index];
                final supabaseRestaurant = restaurantData.firstWhere(
                      (r) => r['id'].toString() == localRestaurant['id'], // تحويل r['id'] إلى نص
                  orElse: () => {
                    'المنيو': null,
                    'الموقع': null,
                    'التواصل': null,
                  },
                );

                // Use Supabase name if available, otherwise fall back to local name
                final displayName = supabaseRestaurant['الاسم'] ?? localRestaurant['name'];

                return Card(
                  elevation: 12,
                  margin: const EdgeInsets.only(bottom: 24), // Fixed to 'bottom'
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          CarouselSlider(
                            items: localRestaurant["photos"].map<Widget>((photo) {
                              return ClipRRect(
                                borderRadius: const BorderRadius.vertical(
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                displayName, // Updated to use dynamic name
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
                                const Icon(Icons.access_time, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  localRestaurant["openTime"],
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final menuUrl = supabaseRestaurant['المنيو'];
                                      if (menuUrl != null) {
                                        _launchURL(menuUrl);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('قائمة الطعام غير متوفرة', style: GoogleFonts.cairo()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.menu_book, color: Colors.black),
                                    label: Text(
                                      "قائمة الطعام",
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final locationUrl = supabaseRestaurant['الموقع'];
                                      if (locationUrl != null) {
                                        _launchURL(locationUrl);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('الموقع غير متوفر', style: GoogleFonts.cairo()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.location_on, color: Colors.black),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final contactUrl = supabaseRestaurant['التواصل'];
                                      if (contactUrl != null) {
                                        _launchURL(contactUrl);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('رقم التواصل غير متوفر', style: GoogleFonts.cairo()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.phone, color: Colors.black),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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