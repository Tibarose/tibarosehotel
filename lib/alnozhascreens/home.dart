

import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'OffersScreen.dart';
import 'RestaurantsScreen.dart';
import 'SubscriptionsScreen.dart';
import 'alnozhahotels.dart';
import 'contact.dart';
import 'dryclean.dart';
import 'grandstores.dart';
import 'hotels.dart';
import 'package:Tibarosehouse/alnozhascreens/photosession.dart';
import 'package:Tibarosehouse/alnozhascreens/swimming.dart';
import 'package:Tibarosehouse/alnozhascreens/garage.dart';
import 'package:Tibarosehouse/alnozhascreens/weedinghall.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  // Header with Carousel Image Slider
  Widget buildHeader(BuildContext context) {
    List<String> imgList = [
      'assets/images/oo.jpg',
      'assets/images/dar1.jpg',
      'assets/images/dar2.jpg',
      'assets/images/tiba1.jpg',
      'assets/images/tiba2.jpg',
      'assets/images/tiba3.jpg',
    ];

    // Define the indices that should open a specific page
    Map<int, Widget> navigableImages = {
      0: RestaurantsScreen(), // Only the first image opens a page
    };

    return Column(
      children: [
        // Tiba Rose House Title
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Center(
            child: Text(
              "تيباروز النزهة",
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
          ),
        ),
        // Carousel Slider
        CarouselSlider.builder(
          itemCount: imgList.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                if (navigableImages.containsKey(index)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => navigableImages[index]!),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imgList[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1.0,
          ),
        ),
      ],
    );
  }  // Categories (Clickable Grid)
  Widget buildCategories(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.restaurant_rounded, "label": "المطاعم", "screen": RestaurantsScreen()},
      {"icon": Icons.bed, "label": "الفنادق", "screen": AlnozhahotelScreen()},
      {"icon": Icons.meeting_room, "label": "القاعات", "screen": WeddingHallsScreen()},
      {"icon": Icons.local_activity, "label": "الانشطه", "screen": ActivitiesScreen()},
      {"icon": Icons.dry_cleaning, "label": "دراي كلين", "screen": DryCleanScreen()},
      {"icon": Icons.celebration, "label": "حفلات وتسويق", "screen": CelebrationsScreen()},
      {"icon": Icons.subscriptions, "label": "الاشتراكات", "screen": SubscriptionsScreen()},
      {"icon": Icons.camera_alt_outlined, "label": "فوتو سيشن", "screen": photosession()},
      {"icon": Icons.storefront_sharp, "label": "Grand store", "screen": grandstores()},
      {"icon": Icons.garage_outlined, "label": "البوابات والجراج", "screen": garage()},
      {"icon": Icons.contact_support, "label": "التواصل معنا", "screen": Contact()},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => categories[index]["screen"],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.indigo[50]!, Colors.indigo[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        categories[index]["icon"],
                        size: 48,
                        color: Colors.indigo[900],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        categories[index]["label"],
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            // Header with Carousel
            buildHeader(context),
            // Scrollable Categories
            Expanded(
              child: SingleChildScrollView(
                child: buildCategories(context),
              ),
            ),
            // Footer with "Powered by MN"
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.code,
                    color: Colors.indigo[900],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Powered by MN",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}