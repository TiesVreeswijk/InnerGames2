import 'package:flutter/material.dart';

class AvatarSelectWidget extends StatelessWidget {
  final String avatarImagePath;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const AvatarSelectWidget({
    Key? key,
    required this.avatarImagePath,
    required this.isSelected,
    this.onTap,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size + 200, // Extra ruimte voor de radio button
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(33),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar Image Container
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      avatarImagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                                            
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Selection Radio Button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6750A4)
                        : const Color(0xFF5A575F),
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.all(4.0), // Padding rondom de kleur
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6750A4),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Grid widget voor meerdere avatars
class AvatarSelectionGrid extends StatefulWidget {
  final List<String> avatarPaths;
  final Function(int)? onAvatarSelected;
  final int? initialSelection;

  const AvatarSelectionGrid({
    Key? key,
    required this.avatarPaths,
    this.onAvatarSelected,
    this.initialSelection,
  }) : super(key: key);

  @override
  State<AvatarSelectionGrid> createState() => _AvatarSelectionGridState();
}

class _AvatarSelectionGridState extends State<AvatarSelectionGrid> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelection;
  }

  @override
  void didUpdateWidget(AvatarSelectionGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selectedIndex when initialSelection changes
    if (widget.initialSelection != oldWidget.initialSelection) {
      selectedIndex = widget.initialSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.70, 
        crossAxisSpacing: 30, // Meer horizontale ruimte tussen avatars
        mainAxisSpacing: 30,   // Meer verticale ruimte tussen avatars
      ),
      itemCount: widget.avatarPaths.length,
      itemBuilder: (context, index) {
        return AvatarSelectWidget(
          avatarImagePath: widget.avatarPaths[index],
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              // Als dezelfde avatar wordt aangeklikt, onselecteer deze
              if (selectedIndex == index) {
                selectedIndex = null;
              } else {
                selectedIndex = index;
              }
            });
            widget.onAvatarSelected
                ?.call(selectedIndex ?? -1); // -1 betekent geen selectie
          },
        );
      },
    );
  }
}

// Helper class voor avatar data
class AvatarData {
  static List<String> getDefaultAvatars() {
    return [
      'assets/images/3d_avatar_1.png', //afbeeldingen werken nu niet
      'assets/images/3d_avatar_2.png',
      'assets/images/3d_avatar_3.png',
      'assets/images/3d_avatar_4.png',
      'assets/images/3d_avatar_5.png',
      'assets/images/3d_avatar_6.png',
      'assets/images/3d_avatar_7.png',
      'assets/images/3d_avatar_8.png',
      'assets/images/3d_avatar_9.png',
    ];
  }
}
