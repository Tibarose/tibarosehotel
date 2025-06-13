import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class agmyContact extends StatelessWidget {
  final List<Map<String, dynamic>> swimmingActivities = [
    {
      "name": "المقترحات والشكاوي",
      "photos": [
        "https://i.imghippo.com/files/vw8482zzI.png",
      ],
      "location": "https://docs.google.com/forms/d/e/1FAIpQLSe0TbVu07KTDF4xoGgSGqxdaxqrl52gCInxoKxlP8EIdBI-5g/viewform",
    },
    {
      "name": "تواصل معنا",
      "photos": [
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/640px-WhatsApp.svg.png",
      ],
      "location": "https://maps.app.goo.gl/uLkQcLuLxFKcZWd47",
      "prices": "https://i.imghippo.com/files/kMvP2562lSY.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set RTL direction
      child: DefaultTabController(
        length: 1, // Three tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "التواصل معنا",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 2,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "التواصل معنا"),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.90,
                  ),
                  itemCount: swimmingActivities.length,
                  itemBuilder: (context, index) {
                    final activity = swimmingActivities[index];
                    return ActivityCard(activity);
                  },
                ),
              ),
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
          if (activity["name"] == "تواصل معنا") {
            _showContactPopup(context); // عرض الـ Popup عند الضغط على "تواصل معنا"
          } else {
            _launchURL(activity["location"]);
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
                height: 120,
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

// 🔹 دالة لعرض نافذة منبثقة تحتوي على أرقام الهواتف
void _showContactPopup(BuildContext context) {
  List<String> phoneNumbers = [
    "01008553801",
    "01152752746",
    "033190120",
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'اتصل بنا',
          style: GoogleFonts.cairo(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: phoneNumbers.map((phone) {
            return ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text(
                phone,
                style: GoogleFonts.cairo(fontSize: 16),
              ),
              onTap: () {
                _launchDialer(phone);
              },
            );
          }).toList(),
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

// 🔹 دالة لفتح تطبيق الهاتف عند النقر على رقم
void _launchDialer(String phoneNumber) async {
  final Uri url = Uri.parse("tel:$phoneNumber");
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'تعذر فتح الهاتف للاتصال بـ $phoneNumber';
  }
}

// 🔹 دالة لفتح أي رابط آخر (الموقع / الأسعار)
void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'تعذر فتح الرابط $url';
  }
}
