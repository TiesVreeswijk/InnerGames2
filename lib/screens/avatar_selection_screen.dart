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

  void _submitSelection() {
    final selectedAvatar = selectedAvatarIndex;
    if (selectedAvatar == null) return;

    final isHost = widget.userData?['isHost'] == true;

    if (isHost) {
      Navigator.pushReplacementNamed(
        context,
        '/ChoosingStories',
        arguments: {
          'isHost': true,
          'gameTitle': widget.userData?['storyTitle'] ?? widget.userData?['gameTitle'] ?? 'HET SKATEPARK',
          'players': [widget.userData?['hostName'] ?? widget.userData?['playerName'] ?? 'Host'],
          'hostName': widget.userData?['hostName'] ?? widget.userData?['playerName'],
          'selectedAvatar': selectedAvatar,
          'pin': widget.userData?['pin'],
        },
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/join-pin',
        arguments: {
          'playerName': widget.userData?['playerName'],
          'pin': widget.userData?['pin'],
          'gameTitle': widget.userData?['gameTitle'],
          'selectedAvatar': selectedAvatar,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
                child: Column(
                  children: [
                    const Text(
                      'Select an avatar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 36),
                    AvatarSelectionGrid(
                      avatarPaths: AvatarData.getDefaultAvatars(),
                      onAvatarSelected: (index) {
                        setState(() {
                          if (index == -1) {
                            selectedAvatarIndex = null;
                          } else {
                            selectedAvatarIndex = index;
                          }
                        });
                      },
                      initialSelection: selectedAvatarIndex,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: selectedAvatarIndex != null ? 1 : 0,
                child: IgnorePointer(
                  ignoring: selectedAvatarIndex == null,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitSelection,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
