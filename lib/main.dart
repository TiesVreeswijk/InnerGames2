import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const SocialityApp());
}

class SocialityApp extends StatelessWidget {
  const SocialityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Tweekracht Sociality',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: const Color(0xFFD4A574),
          fontFamily: 'SF Pro',
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
