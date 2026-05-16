// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'core/firestore_provider.dart';
import 'screens/world_event_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool useFake = false;
  try {
    await Firebase.initializeApp();
  } catch (e) {
    useFake = true;
  }

  final FirebaseFirestore firestore = useFake ? FakeFirebaseFirestore() : FirebaseFirestore.instance;
  if (useFake) {
    // Initialize fake data to avoid nulls
    await firestore.collection('events').doc('dragon_raid').set({
      'slots_filled': 0,
      'max_slots': 15,
    });
  }

  runApp(
    ProviderScope(
      overrides: [
        firestoreProvider.overrideWithValue(firestore),
      ],
      child: const AetherApp(),
    ),
  );
}

class AetherApp extends StatelessWidget {
  const AetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Aether: Cyber',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00E5FF), // Neon Cyan
        scaffoldBackgroundColor: const Color(0xFF05050A), // Deep Black
        textTheme: GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme.apply(bodyColor: Colors.white70, displayColor: Colors.white)),
      ),
      home: const WorldEventScreen(),
    );
  }
}
