import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:finalproject/login.dart';
import 'package:finalproject/firebaseoptions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'finalproject-15cde',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 8, 2, 59)),
        useMaterial3: true,
      ),
      home: const LoginPage()
    );
  }
}

