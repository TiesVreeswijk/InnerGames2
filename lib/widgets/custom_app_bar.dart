import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  
  const CustomAppBar({
    Key? key,
    this.title,
    this.onBackPressed,
    this.showBackButton = true, // Standaard wel terug pijl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFDBDBDB), // Licht grijze achtergrond
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false, // Geen automatische terug pijl
      centerTitle: false,
      titleSpacing: 6.0, 
      leading: showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5A575F)),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE91E63),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
          const SizedBox(width: 20), // Meer ruimte tussen logo en tekst
          Text(
            title ?? 'Sociality',
            style: const TextStyle(
              color: Color(0xFF2C3E7E),
              fontWeight: FontWeight.w900, // Extra dik lettertype
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}