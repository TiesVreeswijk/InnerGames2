import 'package:flutter/material.dart';
import '../widgets/avatar_select.dart';
import '../widgets/custom_app_bar.dart';

class AvatarSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  
  const AvatarSelectionScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  int? selectedAvatarIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 100.0, 24.0, 24.0), // left, top, right, bottom
              child: Column(
                children: [
                  Expanded(
                    child: AvatarSelectionGrid(
                      avatarPaths: AvatarData.getDefaultAvatars(),
                      onAvatarSelected: (index) {
                        setState(() {
                          // -1 betekent geen selectie (gedeselecteerd)
                          if (index == -1) {
                            selectedAvatarIndex = null;
                          } else {
                            selectedAvatarIndex = index;
                          }
                        });
                      },
                      initialSelection: selectedAvatarIndex,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Continue Button - alleen zichtbaar als avatar geselecteerd is
                  if (selectedAvatarIndex != null)
                    SizedBox(
                      width: 160,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Check if user is host to determine navigation
                          bool isHost = widget.userData?['isHost'] == true;
                          
                          if (isHost) {
                            // Navigate to ChoosingStories screen for host
                            Navigator.pushReplacementNamed(
                              context,
                              '/ChoosingStories',
                              arguments: {
                                'isHost': true,
                                'gameTitle': widget.userData?['storyTitle'] ?? widget.userData?['gameTitle'] ?? 'HET SKATEPARK',
                                'players': [widget.userData?['hostName'] ?? widget.userData?['playerName'] ?? 'Host'],
                                'hostName': widget.userData?['hostName'] ?? widget.userData?['playerName'],
                                'selectedAvatar': selectedAvatarIndex,
                                'pin': widget.userData?['pin'],
                              },
                            );
                          } else {
                            // Navigate to ChoosingStories screen for regular players
                            Navigator.pushReplacementNamed(
                              context,
                              '/join-pin',
                              arguments: {
                                'playerName': widget.userData?['playerName'],
                                'pin': widget.userData?['pin'],
                                'gameTitle': widget.userData?['gameTitle'],
                                'selectedAvatar': selectedAvatarIndex,
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE4007D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 60), // Extra ruimte onder de knop
                ],
              ),
            ),
            // Titel (midden boven)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Select an avatar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900, // Extra dik lettertype
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
