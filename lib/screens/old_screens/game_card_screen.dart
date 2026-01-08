import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import 'decision_screen.dart';

class GameCardScreen extends StatefulWidget {
  const GameCardScreen({Key? key}) : super(key: key);

  @override
  State<GameCardScreen> createState() => _GameCardScreenState();
}

class _GameCardScreenState extends State<GameCardScreen> {
  int _currentImageIndex = 0;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final card = gameProvider.getCurrentCard();
        if (card == null) {
          return const Scaffold(
            body: Center(child: Text('No card found')),
          );
        }

        final bool hasImage = card.imagePath != null && card.imagePath!.isNotEmpty;
        final bool hasMultiplePages = card.description != null;
        return Scaffold(
          backgroundColor: const Color(0xFFD4A574),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // WHITE CARD CONTAINER with Story Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // Story Card Image/Content
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: hasImage ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              image: hasImage
                                  ? DecorationImage(
                                      image: AssetImage(card.imagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                // Timer badge (if needed)
                                if (card.timeLimit != null)
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF3949AB),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${card.timeLimit}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                
                                // Card title/content overlay
                                if (card.title != null && card.title!.isNotEmpty)
                                  Positioned(
                                    top: 24,
                                    left: 24,
                                    right: 24,
                                    child: Text(
                                      card.title!,
                                      style: const TextStyle(
                                        color: Color(0xFFE91E8C),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                
                                // Description (if on a text page)
                                if (!hasImage && card.description != null)
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Center(
                                        child: Text(
                                          card.description!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                
                                // Page indicators (dots)
                                if (hasMultiplePages)
                                  Positioned(
                                    bottom: 24,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        3, // Example: 3 pages
                                        (index) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentPage == index
                                                ? const Color(0xFF3949AB)
                                                : Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                
                                // Navigation arrows
                                if (hasMultiplePages)
                                  Positioned(
                                    bottom: 80,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Previous button
                                        if (_currentPage > 0)
                                          IconButton(
                                            onPressed: () {
                                              _pageController.previousPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                              setState(() {
                                                _currentPage--;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              size: 32,
                                              color: Colors.white,
                                            ),
                                          )
                                        else
                                          const SizedBox(width: 48),
                                        
                                        // Next button
                                        IconButton(
                                          onPressed: () {
                                            if (_currentPage < 2) {
                                              _pageController.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                              setState(() {
                                                _currentPage++;
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // WHITE CARD - Decision Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wat doe je?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Choice buttons
                      if (card.choices != null && card.choices!.isNotEmpty)
                        ...card.choices!.map((choice) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DecisionScreen(
                                        choice: choice,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3949AB),
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  choice.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}