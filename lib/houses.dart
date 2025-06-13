import 'dart:ui';
import 'package:Tibarosehouse/tagmooscreens/tibarosetagmoo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'hurgadascreens/Tibarosehurgadascreen.dart';
import 'alnozhascreens/home.dart';
import 'agmyscreens/TibaRoseAgamyScreen.dart';

class HomeSelectionScreen extends StatefulWidget {
  const HomeSelectionScreen({super.key});

  @override
  _HomeSelectionScreenState createState() => _HomeSelectionScreenState();
}

class _HomeSelectionScreenState extends State<HomeSelectionScreen> with SingleTickerProviderStateMixin {
  int _currentAdIndex = 0;
  final TextEditingController _hotelController = TextEditingController();
  late AnimationController _fabController;
  final List<String> _dynamicHotels = [
    'Tiba Rose Fifth Settlement',
    'Tiba Rose Alnozha',
    'Tiba Rose Hurghada',
    'Tiba Rose Alagmy',
  ];

  // Map of predefined hotel screens
  final Map<String, Widget> housePages = <String, Widget>{
    'Tiba Rose Fifth Settlement': Tibarosetagmooscreen(),
    'Tiba Rose Alnozha': MainScreen(),
    'Tiba Rose Hurghada': TibaRosehurgadaScreen(),
    'Tiba Rose Alagmy': TibaRoseAgamyScreen(),
  };

  // Map of hotel names to image assets
  final Map<String, String> _hotelImages = {
    'Tiba Rose Fifth Settlement': 'assets/images/plazahotel1.jpg',
    'Tiba Rose Alnozha': 'assets/images/oo.jpg',
    'Tiba Rose Hurghada': 'assets/images/tiba4.jpg',
    'Tiba Rose Alagmy': 'assets/images/agmylopy1.jpg',
  };

  // Default image for new hotels or errors
  final String _defaultHotelImage = 'assets/images/hotel_default.jpg';

  // Dynamic ad data from Supabase
  List<Map<String, dynamic>> ads = [];
  bool isLoadingAds = true;
  String? adError;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fetchAds();
  }

  Future<void> _fetchAds() async {
    try {
      final response = await Supabase.instance.client
          .from('advertisment')
          .select('id, linkurl, title')
          .order('created_at', ascending: true);

      setState(() {
        ads = response
            .map((ad) {
          final imageUrl = ad['linkurl'] as String;
          if (Uri.tryParse(imageUrl)?.hasScheme ?? false) {
            return {
              'image': imageUrl,
              'url': imageUrl, // Use linkurl for both image and clickable URL
              'title': ad['title']?.toString() ?? 'عرض خاص ${ad['id']}',
            };
          }
          return null;
        })
            .where((ad) => ad != null)
            .cast<Map<String, dynamic>>()
            .toList();
        isLoadingAds = false;
      });
    } catch (e) {
      setState(() {
        adError = 'فشل تحميل الإعلانات: $e';
        isLoadingAds = false;
      });
    }
  }

  void _handleHouseSelection(BuildContext context, String house) {
    if (housePages.containsKey(house)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => housePages[house]!,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => BounceInUp(
          duration: const Duration(milliseconds: 600),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'قريبًا',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: const Color(0xFF0A3D2A),
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$house سيكون متاحًا قريبًا!',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElasticIn(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'حسنًا',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: const Color(0xFFD32F2F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  void _launchAdUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح الإعلان', style: GoogleFonts.cairo(color: Colors.white)),
          backgroundColor: const Color(0xFF0A3D2A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _launchBookingUrl() async {
    const url = 'https://example.com/book-now';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح صفحة الحجز', style: GoogleFonts.cairo(color: Colors.white)),
          backgroundColor: const Color(0xFF0A3D2A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showAddHotelDialog() {
    showDialog(
      context: context,
      builder: (context) => SlideInUp(
        duration: const Duration(milliseconds: 600),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'إضافة فندق جديد',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: const Color(0xFF0A3D2A),
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hotelController,
                    decoration: InputDecoration(
                      hintText: 'أدخل اسم الفندق (مثال: Tiba Rose New Cairo)',
                      hintStyle: GoogleFonts.cairo(color: const Color(0xFF999999)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.cairo(color: const Color(0xFF212121)),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElasticIn(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'إلغاء',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      ElasticIn(
                        child: TextButton(
                          onPressed: () {
                            final newHotel = _hotelController.text.trim();
                            if (newHotel.isNotEmpty && !_dynamicHotels.contains(newHotel)) {
                              setState(() {
                                _dynamicHotels.add(newHotel);
                              });
                              _hotelController.clear();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تمت إضافة الفندق بنجاح!', style: GoogleFonts.cairo(color: Colors.white)),
                                  backgroundColor: const Color(0xFF0A3D2A),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            } else if (_dynamicHotels.contains(newHotel)) {
                              _hotelController.clear();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('الفندق موجود بالفعل!', style: GoogleFonts.cairo(color: Colors.white)),
                                  backgroundColor: const Color(0xFFD32F2F),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'إضافة',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFF0A3D2A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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

  @override
  void dispose() {
    _hotelController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.05).animate(
            CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
          ),
          child: FloatingActionButton(
            onPressed: _launchBookingUrl,
            backgroundColor: const Color(0xFFD32F2F),
            elevation: 8,
            tooltip: 'احجز الآن',
            child: const Icon(Icons.book_online, color: Colors.white),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8EDEB), Color(0xFFB2DFDB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Main content
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: const Color(0xFF0A3D2A).withOpacity(0.5),
                        child: Center(
                          child: Text(
                            'Tiba Rose Hotels',
                            style: GoogleFonts.cairo(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [Color(0xFFF4C430), Color(0xFFF28C38)],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ZoomIn(
                      child: Icon(Icons.hotel, color: const Color(0xFFF4C430), size: 28),
                    ),
                  ),
                  actions: [
                    ZoomIn(
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFFF4C430), size: 28),
                        tooltip: 'إضافة فندق',
                        onPressed: _showAddHotelDialog,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Dynamic Ads Carousel
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              if (isLoadingAds)
                                const Center(child: CircularProgressIndicator())
                              else if (adError != null)
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        adError!,
                                        style: GoogleFonts.cairo(
                                          color: const Color(0xFFD32F2F),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: _fetchAds,
                                        child: Text(
                                          'إعادة المحاولة',
                                          style: GoogleFonts.cairo(
                                            color: const Color(0xFF0A3D2A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (ads.isEmpty)
                                  Center(
                                    child: Text(
                                      'لا توجد إعلانات متاحة',
                                      style: GoogleFonts.cairo(
                                        color: const Color(0xFF212121),
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                else
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 220,
                                      autoPlay: true,
                                      autoPlayInterval: const Duration(seconds: 4),
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.9,
                                      aspectRatio: 16 / 9,
                                      enableInfiniteScroll: true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentAdIndex = index;
                                        });
                                      },
                                    ),
                                    items: ads.asMap().entries.map((entry) {
                                      final ad = entry.value;
                                      final index = entry.key;
                                      return Builder(
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () => _launchAdUrl(ad['url']!),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 12,
                                                        offset: const Offset(0, 6),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Transform.scale(
                                                      scale: 1.05,
                                                      child: Image.network(
                                                        ad['image']!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return const Center(child: CircularProgressIndicator());
                                                        },
                                                        errorBuilder: (context, error, stackTrace) => Container(
                                                          color: Colors.grey[300],
                                                          child: Center(
                                                            child: Text(
                                                              'فشل تحميل الإعلان',
                                                              style: GoogleFonts.cairo(
                                                                color: const Color(0xFFD32F2F),
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 16,
                                                  right: 16,
                                                  child: FadeInUp(
                                                    duration: const Duration(milliseconds: 600),
                                                    delay: Duration(milliseconds: index * 200),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.4),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.2),
                                                            blurRadius: 8,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        ad['title']!,
                                                        style: GoogleFonts.cairo(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 4,
                                                              color: Colors.black.withOpacity(0.4),
                                                              offset: const Offset(2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                              const SizedBox(height: 16),
                              if (!isLoadingAds && adError == null && ads.isNotEmpty)
                                SmoothPageIndicator(
                                  controller: PageController(initialPage: _currentAdIndex),
                                  count: ads.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: const Color(0xFFD32F2F),
                                    dotColor: const Color(0xFFB0BEC5),
                                    expansionFactor: 3,
                                  ),
                                  onDotClicked: (index) {
                                    setState(() {
                                      _currentAdIndex = index;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      // GridView for House Selection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: _dynamicHotels.length,
                          itemBuilder: (context, index) {
                            final houseName = _dynamicHotels[index];
                            final imagePath = _hotelImages[houseName] ?? _defaultHotelImage;
                            return FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              delay: Duration(milliseconds: index * 100),
                              child: GestureDetector(
                                onTap: () => _handleHouseSelection(context, houseName),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8EDEB),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        offset: const Offset(6, 6),
                                        blurRadius: 12,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.7),
                                        offset: const Offset(-6, -6),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    splashColor: const Color(0xFFD32F2F).withOpacity(0.3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFD32F2F).withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              imagePath,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                                _defaultHotelImage,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            houseName,
                                            style: GoogleFonts.cairo(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0A3D2A),
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2,
                                                  color: Colors.black.withOpacity(0.2),
                                                  offset: const Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}