import 'package:firebase_core/firebase_core.dart';
import 'package:thaurus_cnc/app_theme.dart';
import 'package:thaurus_cnc/screens/home_page.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zefsfnmvlkowzxnypeja.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InplZnNmbm12bGtvd3p4bnlwZWphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNzQwMzUsImV4cCI6MjA3Njc1MDAzNX0.faMFciziqqlAlX3v186URBFU5g1ASp3nlhAJlEljmWw',
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thaurus CNC',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: HomePage(),
    );
  }
}
