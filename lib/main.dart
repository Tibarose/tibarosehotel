import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add Supabase import

import 'alnozhascreens/home.dart';
import 'houses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure framework initialization

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://aiiogrxupvumauoybwld.supabase.co',    // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFpaW9ncnh1cHZ1bWF1b3lid2xkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMyNDYzNTEsImV4cCI6MjA1ODgyMjM1MX0.3NSdT6n2t8ChbvykGMwSzNmuzlSFT0yfRTF0oL8ZMPc',    // Replace with your Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Get Supabase client instance
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
        ),
        fontFamily: 'Cairo',
      ),
      home: HomeSelectionScreen(),
    );
  }
}