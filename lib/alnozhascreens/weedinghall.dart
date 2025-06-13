import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeddingHallsScreen extends StatefulWidget {
  const WeddingHallsScreen({super.key});

  @override
  _WeddingHallsScreenState createState() => _WeddingHallsScreenState();
}

class _WeddingHallsScreenState extends State<WeddingHallsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> weddingHalls = [];
  String? errorMessage;

  // Fallback data with only id, name, location, and video
  final List<Map<String, dynamic>> fallbackHalls = [
    {
      "id": "1",
      "name": "Villa Rose",
      "location": "https://maps.app.goo.gl/Tb3rvzxohztoPPqd7",
      "video": "assets/images/villarose.mp4",
    },
    {
      "id": "2",
      "name": "قاعه الاوركيد",
      "location": "https://maps.app.goo.gl/PSxPkv2bwWq3EcSt5",
      "video": "assets/images/orkeed.mp4",
    },
    {
      "id": "3",
      "name": "قاعه البانسيه",
      "location": "https://maps.app.goo.gl/AsL5kFBtsFyKv8Xn7",
      "video": "assets/images/bansee.mp4",
    },
    {
      "id": "4",
      "name": "قاعه التوليب",
      "location": "https://maps.app.goo.gl/uP5LmB1RykdojfdJ7",
      "video": "assets/images/toleeb.mp4",
    },
    {
      "id": "5",
      "name": "قاعه الكاميليا",
      "location": "https://maps.app.goo.gl/mt5ZeRb7PgrvDkjL9",
      "video": "assets/images/kamila.mp4",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeddingHallsData();
  }

  Future<void> _fetchWeddingHallsData() async {
    List<dynamic>? response;
    try {
      response = await supabase
          .from('alnozhahalls')
          .select('id, Hall name, menuhall, bakidgehall, contact')
          .order('id', ascending: true);

      if (response.isEmpty) {
        throw Exception('No wedding halls data found');
      }

      setState(() {
        weddingHalls = List<Map<String, dynamic>>.from(response!).map((hall) {
          final fallbackHall = fallbackHalls.firstWhere(
                (f) => f['id'] == hall['id'].toString(),
            orElse: () => {'name': '', 'location': '', 'video': ''},
          );
          return {
            'id': hall['id'].toString(),
            'name': hall['Hall name'] ?? fallbackHall['name'],
            'location': fallbackHall['location'],
            'contact': hall['contact'] ?? '',
            'menuhall': hall['menuhall'] ?? '',
            'bakidgehall': hall['bakidgehall'] ?? '',
            'video': fallbackHall['video'],
          };
        }).toList();
        print('Fetched wedding halls data: $weddingHalls');
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage = 'فشل في جلب بيانات القاعات من Supabase.';
        weddingHalls = fallbackHalls.map((hall) {
          return {
            'id': hall['id'],
            'name': hall['name'],
            'location': hall['location'],
            'contact': '',
            'menuhall': '',
            'bakidgehall': '',
            'video': hall['video'],
          };
        }).toList();
      });
    }
  }

  Future<void> _launchURL(String url, {bool isContact = false}) async {
    try {
      String finalUrl = url;
      if (isContact && url.startsWith('tel:')) {
        final phoneNumber = url.replaceFirst('tel:', '').replaceAll(RegExp(r'[^0-9]'), '');
        finalUrl = 'https://wa.me/$phoneNumber';
      }
      final uri = Uri.parse(finalUrl);
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

  void _showPricingDialog(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الأسعار غير متوفرة', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "الأسعار",
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
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              loadingBuilder: (context, event) {
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, color: Colors.red));
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "القاعات",
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
        body: weddingHalls.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: GoogleFonts.cairo(color: Colors.red),
                ),
              ),
            Expanded(child: _buildWeddingHallsTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildWeddingHallsTab() {
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
          children: List.generate(weddingHalls.length, (index) {
            final hall = weddingHalls[index];
            return Card(
              elevation: 12,
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            hall["name"],
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        HallVideoPlayer(videoPath: hall["video"]),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final menuhall = hall["menuhall"];
                                      if (menuhall.isNotEmpty) {
                                        _launchURL(menuhall);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('قائمة الطعام غير متوفرة', style: GoogleFonts.cairo()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.card_giftcard, color: Colors.black),
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
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _showPricingDialog(context, hall["bakidgehall"]);
                                    },
                                    icon: const Icon(Icons.attach_money, color: Colors.black),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final location = hall["location"];
                                      if (location.isNotEmpty) {
                                        _launchURL(location);
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final contact = hall["contact"];
                                      if (contact.isNotEmpty) {
                                        _launchURL(contact, isContact: true);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('رابط التواصل غير متوفر', style: GoogleFonts.cairo()),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class HallVideoPlayer extends StatefulWidget {
  final String videoPath;

  const HallVideoPlayer({required this.videoPath, super.key});

  @override
  _HallVideoPlayerState createState() => _HallVideoPlayerState();
}

class _HallVideoPlayerState extends State<HallVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50.0,
            ),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}