import 'package:Tibarosehouse/hurgadascreens/hurgadacontact.dart';
import 'package:Tibarosehouse/hurgadascreens/hurgadarestaurant.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../agmyscreens/agmyactivity.dart';
import '../agmyscreens/agmyrestuarant.dart';
import '../alnozhascreens/OffersScreen.dart';
import '../alnozhascreens/RestaurantsScreen.dart';
import '../alnozhascreens/contact.dart';
import '../alnozhascreens/hotels.dart';
import 'hurgadahotel.dart';
import '../alnozhascreens/photosession.dart';
import '../alnozhascreens/swimming.dart';
import '../alnozhascreens/garage.dart';
import '../alnozhascreens/weedinghall.dart';
import '../agmyscreens/agmyhotel.dart';

class TibaRosehurgadaScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://i.imghippo.com/files/esS4006vY.jpg',
    'https://i.imghippo.com/files/uvGs7704ubs.jpg',
    'https://i.imghippo.com/files/ZkI9254EU.jpg',
    'https://i.imghippo.com/files/nS8940YI.jpg',
  ];

  final List<CategoryItem> categories = [
    CategoryItem(icon: Icons.restaurant_rounded, label: "المطاعم", screen: HurgadarestaurantScreen()),
    CategoryItem(icon: Icons.bed, label: "hotel الفندق", screen: HurgadaHotelScreen()),
    CategoryItem(icon: Icons.local_activity, label: "الانشطه", screen: AgmyActivityScreen()),
    CategoryItem(icon: Icons.celebration, label: "حفلات وتسويق", screen: CelebrationsScreen()),
    CategoryItem(icon: Icons.contact_support, label: "التواصل معنا", screen: hurgadacontact()),
  ];

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "تيباروز الغردقة",
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
          ),
        ),
        CarouselSlider.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TibaRosehurgadaScreen()),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            buildHeader(context),
            Expanded(child: ListView(children: [buildCategories(context)])),
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
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
                  MaterialPageRoute(builder: (context) => categories[index].screen),
                );
              },
              splashColor: Colors.indigo.withOpacity(0.2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categories[index].icon, size: 48, color: Colors.indigo[900]),
                    SizedBox(height: 12),
                    Text(
                      categories[index].label,
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
          );
        },
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code, color: Colors.indigo[900], size: 18),
          SizedBox(width: 8),
          Text(
            "Powered by MN",
            style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.indigo[900]),
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;
  final Widget screen;
  CategoryItem({required this.icon, required this.label, required this.screen});
}
