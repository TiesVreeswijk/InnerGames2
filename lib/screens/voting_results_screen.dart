import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'question_screen.dart';

class VotingResultsScreen extends StatelessWidget {
  const VotingResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final card = gameProvider.getCurrentCard();
        if (card == null || card.choices == null) {
          return const Scaffold(
            body: Center(child: Text('No card found')),
          );
        }

        final results = gameProvider.getCurrentVotingResults();
        final totalVotes = gameProvider.currentSession?.players.length ?? 0;

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
                // WHITE CARD - Story Card (smaller)
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: card.imagePath != null
                          ? DecorationImage(
                              image: AssetImage(card.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: card.imagePath == null ? const Color(0xFFF5E6D3) : null,
                    ),
                    child: Stack(
                      children: [
                        if (card.timeLimit != null)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF3949AB),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${card.timeLimit}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // WHITE CARD - Voting Results
                Expanded(
                  child: Container(
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
                        
                        // Results for each choice
                        Expanded(
                          child: ListView.builder(
                            itemCount: card.choices!.length,
                            itemBuilder: (context, index) {
                              final choice = card.choices![index];
                              final votes = results[choice.id] ?? 0;
                              final percentage = totalVotes > 0
                                  ? (votes / totalVotes * 100).round()
                                  : 0;
                              
                              // Determine color based on votes
                              Color buttonColor;
                              if (votes > totalVotes / 2) {
                                buttonColor = const Color(0xFF4CAF50); // Green - most votes
                              } else if (votes > 0) {
                                buttonColor = const Color(0xFFE57373); // Red - some votes
                              } else {
                                buttonColor = const Color(0xFF3949AB); // Blue - no votes
                              }
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          choice.text,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '$votes/$totalVotes gekozen',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Next button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QuestionScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E8C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Volgende',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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