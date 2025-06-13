import 'package:Tibarosehouse/alnozhascreens/video.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class grandstores extends StatelessWidget {
  final List<Map<String, dynamic>> swimmingActivities = [
    {
      "name": "صيدليه العزبي",
      "icon": Icons.pool,
      "photos": [
        "https://i.imghippo.com/files/rD4908Q.jpg",
        "https://i.imghippo.com/files/XQN1736lMo.jpg",

      ],
      "details": "الابعاد ( 12.50م × 25م ) العمق (1م - 4م ) ",

      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/bfH5413qs.jpg",
    },
    {
      "name": "COFFEE CORNER",
      "icon": Icons.pool,
      "photos": [
        "https://i.imghippo.com/files/cCL2715Bkg.jpg",
        "https://i.imghippo.com/files/XQN1736lMo.jpg",

      ],
      "details": "الابعاد ( 11م × 17م ) العمق (1.40م) ",
      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/kMvP2562lSY.jpg",
    },
    {
      "name": "صانع السعاده",
      "icon": Icons.pool,
      "photos": [
        "https://i.imghippo.com/files/SFdg1513KtU.jpg",
        "https://i.imghippo.com/files/XQN1736lMo.jpg",

      ],
      "details": "الابعاد ( 9م × 11م ) العمق (1.60م - 1.80م) ",
      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/Yo6167j.jpg",
    },  {
      "name": "SELEMA GOLD",
      "icon": Icons.pool,
      "photos": [
        "https://i.imghippo.com/files/az7277yY.jpg",
        "https://i.imghippo.com/files/XQN1736lMo.jpg",
      ],
      "details": " العمق (1.60م) ",
      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/yT7371OmY.jpg",
    }, {
      "name": "Piece of Art furniture",
      "icon": Icons.pool,
      "photos": [
        "https://i.imghippo.com/files/ousx1355k.jpg",
        "https://i.imghippo.com/files/XQN1736lMo.jpg",
      ],
      "details": " العمق (1.60م) ",
      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/yT7371OmY.jpg",
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set RTL direction
      child: DefaultTabController(
        length: 4, // Three tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Grand store",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 2,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Grand store"),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Swimming Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.90, // Adjust the aspect ratio for better appearance
                  ),
                  itemCount: swimmingActivities.length,
                  itemBuilder: (context, index) {
                    final activity = swimmingActivities[index];
                    return ActivityCard(activity);
                  },
                ),
              ),
              // Schools Tab
              // Coaching Tab
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (activity["name"] == "السباحة") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SwimmingPoolsScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailsScreen(activity),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                activity["photos"][0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120, // Fixed height for images
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                activity["name"],
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> activity;

  ActivityDetailsScreen(this.activity);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            activity["name"],
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          leading: null, // Remove the default back button
          actions: [

          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CarouselSlider(
                items: activity["photos"].map<Widget>((photo) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      photo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
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
              SizedBox(height: 16),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.location_on),
                label: Text("عرض الموقع على خرائط جوجل"),
                onPressed: () async {
                  final url = activity["location"];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not open $url';
                  }
                },
              ),
              SizedBox(height: 5,),

              if (activity["name"] == "كرة السلة" || activity["name"] == "كرة القدم"|| activity["name"] == "كرة الطائره"|| activity["name"] == "الاسكواش"|| activity["name"] == "بادل")
                ElevatedButton.icon(
                  icon: Icon(Icons.book),
                  label: Text("احجز الآن", style: GoogleFonts.cairo()),
                  onPressed: () async {
                    final url = activity["book"];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not open $url';
                    }
                  },
                ),
              SizedBox(height: 5,),



            ],
          ),
        ),
      ),
    );
  }
}

void _showPricePopup(BuildContext context, String priceImageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'أسعار المسبح',
          style: GoogleFonts.cairo(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity, // Make the container take full width
              height: 350, // Adjust the height as needed
              child: Image.network(
                priceImageUrl,
                fit: BoxFit.contain, // You can use BoxFit.cover to fill the container or BoxFit.fitWidth
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            child: Text('إغلاق', style: GoogleFonts.cairo()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void _showPricingDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("الاسعار ", style: GoogleFonts.cairo(),textDirection: TextDirection.rtl),
        content: Image.network(imageUrl), // Displaying the image in the dialog
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("إغلاق", style: GoogleFonts.cairo()),
          ),
        ],
      );
    },
  );
}