import 'package:firebase_core/firebase_core.dart';

import 'screens/welcome/welcome_screen.dart';
import 'theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is the free verstion of Flutter Chat App UI Kit
  // Full code: https://www.patreon.com/posts/chat-app-ui-for-93094811
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Talk',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.light,
      home: const WelcomeScreen(),
    );
  }
}