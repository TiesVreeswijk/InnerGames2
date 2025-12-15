import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_models.dart';
import 'game_card_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? _selectedPath;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final card = gameProvider.getCurrentCard();
        final isHost = gameProvider.isHost;
        
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
                const SizedBox(height: 40),
                // Question card with icon
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Waarom jouw keuze?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3949AB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Large centered icon/illustration
                Expanded(
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E8C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          // Question marks in corners
                          const Positioned(
                            top: 30,
                            left: 30,
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 30,
                            right: 30,
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 30,
                            left: 30,
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 30,
                            right: 30,
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Eyes in center
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEye(),
                                const SizedBox(width: 30),
                                _buildEye(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // HOST: Path selection choices
                if (isHost && card?.choices != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kies het pad voor het spel',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...card!.choices!.map((choice) {
                          final isSelected = _selectedPath == choice.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPath = choice.id;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3949AB)
                                    : const Color(0xFF3949AB).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: const Color(0xFFE91E8C), width: 3)
                                    : null,
                              ),
                              child: Text(
                                choice.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        if (_selectedPath != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  final selectedChoice = card.choices!.firstWhere(
                                    (c) => c.id == _selectedPath,
                                  );
                                  gameProvider.nextCard(selectedChoice.nextCardId);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GameCardScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE91E8C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Doorgaan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                
                // NON-HOST: Waiting message
                if (!isHost)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Wachten op host om het pad te kiezen...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEye() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            color: Color(0xFFE91E8C),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
