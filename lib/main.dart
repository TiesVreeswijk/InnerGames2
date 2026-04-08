import 'package:flutter/material.dart';

// Import ONLY the screens we created that work
import 'screens/host_name_entry_screen.dart';
import 'screens/host_share_screen.dart';
import 'screens/join_pin_screen.dart';
import 'screens/name_entry_screen.dart';
import 'screens/lobby_screen.dart';
import 'screens/create_join_screen.dart';
import 'screens/share_game_screen.dart';
import 'screens/story_screen.dart';

// V2 imports Ryan
import 'screens/splash_screen.dart';
import 'screens/splash_screen2.dart';
import 'screens/welcome_screenV2.dart';
import 'screens/home_screenV2.dart';
//test2
void main() {
  runApp(const SocialityApp());
}

class SocialityApp extends StatelessWidget {
  const SocialityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sociality',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'SF Pro Text',
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        print('🔄 Navigating to: ${settings.name}');
        
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const LobbyScreen(
                isHost: false,
                gameTitle: 'HET SKATEPARK',
              ),
            );

          case '/splash':
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );

          case '/splash2':
            return MaterialPageRoute(
              builder: (context) => const SplashScreen2(),
            );

          case '/welcome':
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreenv2(),
            );

          case '/home':
            return MaterialPageRoute(
              builder: (context) => const HomeScreenv2(),
            );
            
          case '/host-name-entry':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => HostNameEntryScreen(
                storyTitle: args?['storyTitle'] as String? ?? 'HET SKATEPARK',
              ),
            );
            
          case '/host-share':
            final args = settings.arguments as Map<String, dynamic>?;
            print('📍 Host share args: $args');
            
            return MaterialPageRoute(
              builder: (context) => HostShareScreen(
                pin: args?['pin'] as String? ?? '1234',
                storyTitle: args?['storyTitle'] as String? ?? 'HET SKATEPARK',
                hostName: args?['hostName'] as String? ?? 'Host',
              ),
            );
            
          case '/join-pin':
            print('📍 Navigating to join-pin screen');
            return MaterialPageRoute(
              builder: (context) => const JoinPinScreen(),
            );

          case '/create-join':
            return MaterialPageRoute(
              builder: (context) => const CreateJoinScreen(),
            );

          case '/share-game':
            return MaterialPageRoute(
              builder: (context) => const ShareGameScreen(),
            );

          case '/name-entry':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => NameEntryScreen(
                pin: args?['pin'] as String? ?? '1234',
              ),
            );
            
          case '/join-qr':
            // Placeholder for now - you'll add this later
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                backgroundColor: const Color(0xFFF5E6D3),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: const Text('QR Scanner'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 64, color: Color(0xFF2C3E7E)),
                      const SizedBox(height: 16),
                      const Text(
                        'QR Scanner - Coming Soon',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              ),
            );
            
          case '/lobby':
            final args = settings.arguments as Map<String, dynamic>?;
            print('📍 Lobby args: $args');
            
            return MaterialPageRoute(
              builder: (context) => LobbyScreen(
                isHost: args?['isHost'] as bool? ?? false,
                gameTitle: args?['gameTitle'] as String? ?? 'HET SKATEPARK',
                players: (args?['players'] as List<dynamic>?)?.cast<String>() ?? [],
              ),
            );
            
          case '/story':
            return MaterialPageRoute(
              builder: (context) => const StoryScreen(),
            );

          case '/game':
            return MaterialPageRoute(
              builder: (context) => const StoryScreen(),
            );

          case '/game-placeholder':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                backgroundColor: const Color(0xFFD89B6A),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: const Text('Game Starting'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sports_esports, size: 64, color: Color(0xFF2C3E7E)),
                      const SizedBox(height: 16),
                      const Text(
                        'Game will start here...',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                        ),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  ),
                ),
              ),
            );
            
            
          default:
            print('❌ Route not found: ${settings.name}');
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Not Found'),
                  backgroundColor: Colors.white,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Route "${settings.name}" not found',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                        ),
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}