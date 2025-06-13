import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Map<String, dynamic>> swimmingActivities = [];
  List<Map<String, dynamic>> schoolActivities = [];
  List<Map<String, dynamic>> coachingActivities = [];
  List<Map<String, dynamic>> gymActivities = [];
  List<Map<String, dynamic>> contactInfo = []; // Renamed for clarity

  bool isLoading = true;
  String? errorMessage;

  final SupabaseClient supabase = Supabase.instance.client;

  // Local data for photos and details (since they are not in the database)
  final Map<String, Map<String, dynamic>> localData = {
    "tibarose_nsfolempy": {
      "name": "تيباروز (نصف اوليمبى)",
      "photos": [
        "assets/images/nsfolempy.jpg",
      ],
      "details": "الابعاد ( 12.50م × 25م ) العمق (1م - 4م )",
    },
    "grandtibarosepool": {
      "name": "جراند تيباروز",
      "photos": [
        "assets/images/grandtibapool1.jpg",
        "assets/images/grand1.jpg",
        "assets/images/grandtibapool3.jpg",
      ],
      "details": "الابعاد ( 11م × 17م ) العمق (1.40م)",
    },
    "paradisepool": {
      "name": "باراديس",
      "photos": [
        "assets/images/paradisemain.jpg",
        "assets/images/paradisepool1.jpg",
        "assets/images/paradisepool2.jpg",
      ],
      "details": "الابعاد ( 9م × 11م ) العمق (1.60م - 1.80م)",
    },
    "tibarose_oval": {
      "name": "تيباروز بيضاوي",
      "photos": [
        "assets/images/swimmingtibarose.jpg",
        "assets/images/swimmingtibarose.jpg",
      ],
      "details": "العمق (1.60م)",
    },
    "balleh": {
      "name": "بالية",
      "photos": [
        "assets/images/balleh1.jpg",
        "assets/images/balleh2.jpg",
      ],
      "details": "تعلم الباليه في بيئة مليئة بالإبداع والفن.",
    },
    "basketball": {
      "name": "كرة السلة",
      "photos": [
        "assets/images/basketball1.jpg",
        "assets/images/basketball2.jpg",
      ],
      "details": "العب كرة السلة في ملاعبنا الحديثة.",
    },
    "football": {
      "name": "كرة القدم",
      "photos": [
        "assets/images/football1.jpg",
        "assets/images/football2.jpg",
      ],
      "details": "تجربة ملاعب كرة قدم عالية الجودة.",
    },
    "volleyball": {
      "name": "كرة الطائره",
      "photos": [
        "assets/images/vollyball.png",
      ],
      "details": "العب كرة الطائره في ملاعبنا الحديثة.",
    },
    "skoash": {
      "name": "الاسكواش",
      "photos": [
        "assets/images/squash.jpg",
      ],
      "details": "العب الاسكواش في ملاعبنا الحديثة.",
    },
    "quran": {
      "name": "تحفيظ القران",
      "photos": [
        "assets/images/quran.jpg",
      ],
      "details": "تحفيظ القران.",
    },
    "karate": {
      "name": "الكارتية",
      "photos": [
        "assets/images/karate2.jpg",
        "assets/images/karate1.jpg",
      ],
      "details": "تعلم فنون الدفاع عن النفس مع التدريب المهني.",
    },
    "gombaz": {
      "name": "جمباز",
      "photos": [
        "assets/images/gombaz.jpg",
      ],
      "details": "العب جمباز في ملاعبنا الحديثة.",
    },
    "taikondo": {
      "name": "تايكوندو",
      "photos": [
        "assets/images/tikondo.jpg",
      ],
      "details": "تعلم تايكوندو مع مدربين محترفين.",
    },
    "kongfo": {
      "name": "كونج فو",
      "photos": [
        "assets/images/kongfo1.jpg",
        "assets/images/kongfo2.jpg",
      ],
      "details": "تعلم الكونغ فو في مركزنا المتخصص.",
    },
    "padel": {
      "name": "بادل",
      "photos": [
        "assets/images/padel.jpg",
      ],
      "details": "العب باديل في ملاعبنا الحديثة.",
    },
    "booleng": {
      "name": "بولينغ",
      "photos": [
        "assets/images/booling1.jpg",
        "assets/images/booling2.jpg",
      ],
      "details": "العب بولينغ في ملاعبنا الحديثة.",
    },
    "bingbong": {
      "name": "بنج بونج",
      "photos": [
        "assets/images/bingbong.jpg",
      ],
      "details": "العب بنج بونج في ملاعبنا الحديثة.",
    },
    "paradisegym": {
      "name": "جيم براديس",
      "photos": [
        "assets/images/paradise1.jpg",
        "assets/images/paradise2.jpg",
        "assets/images/paradise3.jpg",
        "assets/images/paradise4.jpg",
        "assets/images/paradise5.jpg",
        "assets/images/paradise6.jpg",

      ],
      "details": "استمتع بكثير من الانشطه داخل الجيم.",
    },
    "acasiagym": {
      "name": "جيم اكاسيا",
      "photos": [
        "assets/images/acasia1.jpg",
        "assets/images/acasia2.jpg",
        "assets/images/acasia3.jpg",
        "assets/images/acasia4.jpg",
      ],
      "details": "استمتع بكثير من الانشطه داخل الجيم.",
    },
  };

  @override
  void initState() {
    super.initState();
    fetchActivitiesData();
  }

  Future<void> fetchActivitiesData() async {
    try {
      // Fetch swimming pools data
      final swimmingResponse = await supabase
          .from('alnozhaswimmingpools')
          .select('namepool, poolprice, poollocation, contact');

      // Fetch academy activities data with ORDER BY id
      final academyResponse = await supabase
          .from('academyactivity')
          .select('academyname, academyprice, academylocation, contactinfo')
          .order('id', ascending: true); // Ensure ordering by id

      // Fetch recreational activities data
      final trfehyResponse = await supabase
          .from('trfehyactivity')
          .select('trfehyname, trfehyprice, trfehylocation, contactinfo');

      // Fetch gym activities data
      final gymResponse = await supabase
          .from('gymactivity')
          .select('gymname, gymprice, gymlocation, contactinfoo');

      // Fetch contact information
      final contactResponse = await supabase
          .from('contactpublic')
          .select('phone1, phone2, phone3, phone4');

      setState(() {
        // Merge swimming data with local data
        swimmingActivities = (swimmingResponse as List<dynamic>).map<Map<String, dynamic>>((activity) {
          final local = localData[activity['namepool']] ?? {};
          return {
            "name": local['name'] ?? activity['namepool'],
            "photos": local['photos'] ?? [],
            "details": local['details'] ?? '',
            "location": activity['poollocation'],
            "prices": activity['poolprice'],
            "contact": activity['contact'],
          };
        }).toList();

        // Merge academy data with local data
        schoolActivities = (academyResponse as List<dynamic>).map<Map<String, dynamic>>((activity) {
          final local = localData[activity['academyname']] ?? {};
          return {
            "name": local['name'] ?? activity['academyname'],
            "photos": local['photos'] ?? [],
            "details": local['details'] ?? '',
            "location": activity['academylocation'],
            "prices": activity['academyprice'],
            "contact": activity['contactinfo'],
          };
        }).toList();

        // Merge recreational data with local data
        coachingActivities = (trfehyResponse as List<dynamic>).map<Map<String, dynamic>>((activity) {
          final local = localData[activity['trfehyname']] ?? {};
          return {
            "name": local['name'] ?? activity['trfehyname'],
            "photos": local['photos'] ?? [],
            "details": local['details'] ?? '',
            "location": activity['trfehylocation'],
            "prices": activity['trfehyprice'],
            "contact": activity['contactinfo'],
          };
        }).toList();

        // Merge gym data with local data
        gymActivities = (gymResponse as List<dynamic>).map<Map<String, dynamic>>((activity) {
          final local = localData[activity['gymname']] ?? {};
          return {
            "name": local['name'] ?? activity['gymname'],
            "photos": local['photos'] ?? [],
            "details": local['details'] ?? '',
            "location": activity['gymlocation'],
            "prices": activity['gymprice'],
            "contact": activity['contactinfoo'],
          };
        }).toList();

        // Map contact information directly from contactResponse
        contactInfo = (contactResponse as List<dynamic>).map<Map<String, dynamic>>((contact) {
          return {
            "phone1": contact['phone1'] ?? 'غير متوفر',
            "phone2": contact['phone2'] ?? 'غير متوفر',
            "phone3": contact['phone3'] ?? 'غير متوفر',
            "phone4": contact['phone4'] ?? 'غير متوفر',
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'فشل في جلب البيانات من Supabase.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "الأنشطة",
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
                Tab(text: "السباحه"),
                Tab(text: "الاكاديميات"),
                Tab(text: "ترفيهي"),
                Tab(text: "GYM"),
                Tab(text: "التواصل"),
              ],
            ),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!, style: GoogleFonts.cairo(color: Colors.red)))
              : TabBarView(
            children: [
              // Swimming Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
              // Schools Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.90,
                  ),
                  itemCount: schoolActivities.length,
                  itemBuilder: (context, index) {
                    final activity = schoolActivities[index];
                    return ActivityCard(activity);
                  },
                ),
              ),
              // Coaching Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.90,
                  ),
                  itemCount: coachingActivities.length,
                  itemBuilder: (context, index) {
                    final activity = coachingActivities[index];
                    return ActivityCard(activity);
                  },
                ),
              ),
              // Gym Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.90,
                  ),
                  itemCount: gymActivities.length,
                  itemBuilder: (context, index) {
                    final activity = gymActivities[index];
                    return ActivityCard(activity);
                  },
                ),
              ),
              // Contact Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: contactInfo.length,
                  itemBuilder: (context, index) {
                    final contact = contactInfo[index];
                    return ContactCard(contact);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetailsScreen(activity),
            ),
          );
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
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

class ContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;

  ContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "معلومات التواصل",
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ContactButton(label: "رقم 1", phone: contact['phone1']),
            ContactButton(label: "رقم 2", phone: contact['phone2']),
            ContactButton(label: "رقم 3", phone: contact['phone3']),
            ContactButton(label: "رقم 4", phone: contact['phone4']),
          ],
        ),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final String label;
  final String phone;

  ContactButton({required this.label, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.phone),
        label: Text(
          "$label: $phone",
          style: GoogleFonts.cairo(),
        ),
        onPressed: phone != 'غير متوفر'
            ? () async {
          final url = 'tel:$phone';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لا يمكن فتح رابط الاتصال')),
            );
          }
        }
            : null,
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
              Text(
                activity["details"],
                style: GoogleFonts.cairo(fontSize: 16),
                textAlign: TextAlign.center,
              ),
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
              SizedBox(height: 5),
              if (["كرة السلة", "كرة القدم", "كرة الطائره", "الاسكواش", "بادل"]
                  .contains(activity["name"]))
                ElevatedButton.icon(
                  icon: Icon(Icons.phone),
                  label: Text("التواصل", style: GoogleFonts.cairo()),
                  onPressed: () async {
                    final url = activity["contact"];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not open $url';
                    }
                  },
                ),
              SizedBox(height: 5),
              ElevatedButton.icon(
                icon: Icon(Icons.price_change),
                label: Text("عرض الأسعار"),
                onPressed: () {
                  _showPricingDialog(context, activity["prices"]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPricingDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "الاسعار",
          style: GoogleFonts.cairo(),
          textDirection: TextDirection.rtl,
        ),
        content: Container(
          height: 300,
          width: 300,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
            loadingBuilder: (context, event) {
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
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "إغلاق",
              style: GoogleFonts.cairo(),
            ),
          ),
        ],
      );
    },
  );
}