import 'package:flutter/material.dart';

class InterventionCard extends StatelessWidget {
  final String subtitle;
  final String title;
  final List<Map<String, String>> kaartDetails;
  final VoidCallback? onContinue;

  const InterventionCard({
    Key? key,
    required this.subtitle,
    required this.title,
    required this.kaartDetails,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Material(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFD4006B),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: kaartDetails.map((kaartData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kaartData['image']!.startsWith('http')
                                    ? Image.network(
                                        kaartData['image']!,
                                        width: 90,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        kaartData['image']!,
                                        width: 90,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: onContinue,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.chevron_right,
                              size: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
