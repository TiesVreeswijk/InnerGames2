import 'package:flutter/material.dart';

class NameInputWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const NameInputWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.contain,
          alignment: Alignment(0, -0.4),
          opacity: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 93),
            TextField(
              controller: controller,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E7E),
              ),
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                  fontSize: 45,
                  color: Colors.grey.shade400,
                ),
                filled: true,
                fillColor: const Color(0xFFDBDBDB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 24,
                ),
                counterText: '',
              ),
              maxLength: 20,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => onSubmitted(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}