import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import 'decision_screen.dart';

/// Displays game cards - uses actual screen images from design
class SimpleCardScreen extends StatelessWidget {
  const SimpleCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final card = gameProvider.getCurrentCard();
        if (card == null) {
          return const Scaffold(
            body: Center(child: Text('Geen kaart gevonden')),
          );
        }

        final bool hasImage = card.imagePath != null && card.imagePath!.isNotEmpty;
        final bool isHost = gameProvider.isHost;

        return Scaffold(
          backgroundColor: const Color(0xFFD4A574),
          body: SafeArea(
            child: Stack(
              children: [
                // Main card display
                Column(
                  children: [
                    // Top back button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    
                    // Card image - full screen display
                    if (hasImage)
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                card.imagePath!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackCard(card);
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: _buildFallbackCard(card),
                      ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
                
                // Host controls overlay (bottom)
                if (isHost)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: _buildHostControls(context, gameProvider, card),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackCard(GameCard card) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E8C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            card.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHostControls(BuildContext context, GameProvider gameProvider, GameCard card) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to previous card
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3949AB),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Vorige'),
            ),
          ),
          const SizedBox(width: 12),
          // Next/Decision button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (card.type == CardType.decision && card.choices != null && card.choices!.isNotEmpty) {
                  // Go to decision screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DecisionScreen(),
                    ),
                  );
                } else {
                  // Go to next card
                  // TODO: Navigate to next card in sequence
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                card.type == CardType.decision ? 'Stemmen' : 'Volgende',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
