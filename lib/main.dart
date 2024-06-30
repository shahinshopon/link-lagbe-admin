import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:link_lagbe_update/ui/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'link-lagbe-admin',
      options: const FirebaseOptions(
    apiKey: "AIzaSyAUkn6CRjCPH6lr4NtTEmjRXjh4xji10ww",
    appId: "1:929421517737:web:b91e08e74d52c54b0c9ab8",
    messagingSenderId: "929421517737",
    projectId: "link-lagbe",
    storageBucket: "link-lagbe.appspot.com",
  ));
  runApp(MyApp());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      //  name: 'link-lagbe-admin',
//        options: const FirebaseOptions(
//   apiKey: "AIzaSyAUkn6CRjCPH6lr4NtTEmjRXjh4xji10ww",
//   appId: "1:929421517737:web:b91e08e74d52c54b0c9ab8",
//   messagingSenderId: "929421517737",
//   projectId: "link-lagbe")
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'Link Lagbe Admin',
      home: SplashScreen(),
    );
  }
}
