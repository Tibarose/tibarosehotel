import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DryCleanScreen extends StatefulWidget {
  @override
  _DryCleanScreenState createState() => _DryCleanScreenState();
}

class _DryCleanScreenState extends State<DryCleanScreen> {
  final List<String> dryCleanPhotos = [
    "assets/images/drycleannn.jpg",
  ];

  String? priceUrl; // To store the price URL from Supabase
  bool isLoading = true; // To handle loading state
  String? errorMessage; // To handle error state

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchDryCleanData();
  }

  // Fetch price from Supabase
  Future<void> fetchDryCleanData() async {
    try {
      final response = await supabase
          .from('dryclean')
          .select('price')
          .eq('id', '1') // Assuming you want the record with id=1
          .single(); // Expecting a single record

      setState(() {
        priceUrl = response['price'] as String?;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching dry clean data: $e');
      setState(() {
        errorMessage = 'فشل في جلب بيانات الدراي كلين من Supabase.';
        isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح رابط الأسعار')),
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
            "الدراي كلين",
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
            child: Text(
              errorMessage!,
              style: GoogleFonts.cairo(color: Colors.red),
            ),
          )
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel for dry clean photos
                  Card(
                    elevation: 12,
                    margin: EdgeInsets.only(bottom: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CarouselSlider(
                      items: dryCleanPhotos.map<Widget>((photoUrl) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            photoUrl,
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
                  ),
                  // خدماتنا Card
                  Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32, // Full screen width with padding
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "خدماتنا",
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "غسيل وتجفيف\nتنظيف جاف\nكي\nتغليف و احضار",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Call to Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32, // Full width with padding
                        child: ElevatedButton.icon(
                          onPressed: priceUrl != null
                              ? () => _launchURL(priceUrl!)
                              : null, // Disable button if priceUrl is null
                          icon: Icon(Icons.attach_money, color: Colors.black),
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
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}