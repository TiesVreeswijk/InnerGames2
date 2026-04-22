import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/join_code_panel.dart';

class HostShareScreen extends StatelessWidget {
  final String pin;
  final String storyTitle;
  final String hostName;

  const HostShareScreen({
    Key? key,
    required this.pin,
    required this.storyTitle,
    required this.hostName,
  }) : super(key: key);

  void _goToLobby(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/lobby_host',
      arguments: {
        'isHost': true,
        'gameTitle': storyTitle,
        'pin': pin,
        'players': [hostName],
        'hostName': hostName,
      },
    );
  }

  void _closeScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: JoinCodePanel(
                      pin: pin,
                      showCloseButton: true,
                      onClose: () => _closeScreen(context),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _goToLobby(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E7E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start Spel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}