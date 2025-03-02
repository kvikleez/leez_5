import 'package:flutter/material.dart';
import 'package:leez/frontend/models/property_provider.dart';
import 'package:leez/frontend/screens/common/auth/signup.dart';
import 'package:leez/frontend/screens/common/splash.dart';
import 'package:leez/test.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leez/firebase_options.dart'; // Generate this using FlutterFire CLI

// Create AuthProvider to manage authentication state
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enable DevicePreview in debug mode
      builder: (context) => MultiProvider(
        providers: [
          // Add AuthProvider
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          // Property provider
          ChangeNotifierProvider(
            create: (_) => PropertyProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context), // For DevicePreview
      builder: DevicePreview.appBuilder, 
      title: 'Leez A Rental Platform',
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}