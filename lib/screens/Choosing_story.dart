import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ChoosingStoryScreen extends StatelessWidget {
  const ChoosingStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Light grey background like in image
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Aanbevolen" Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      
                        child: const Text(
                          'Aanbevolen:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Story Cards
                      _buildStoryCard(
                        context,
                        title: '1ST STORY\nHET SKATEPARK',
                        imageUrl: 'assets/images/skatepark_story.png',
                        onTap: () {
                          _showStoryOptions(context, 'HET SKATEPARK');
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Second story card
                      _buildStoryCard(
                        context,
                        title: '2ND STORY\nDE APOTHEKER ASSISTENTEN',
                        imageUrl: 'assets/images/apothekerAssistenten_story.png',
                        onTap: () {
                          _showStoryOptions(context, 'SPEELKAARTJES DE APOTHEKER ASSISTENTEN');
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Placeholder cards (for future stories)
                      _buildPlaceholderCard(context),
                      
                      const SizedBox(height: 100), // Space for fixed bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // // Fixed bottom bar
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      //   decoration: const BoxDecoration(
      //     color: Color(0xFFF2F2F2), // Match background
      //   ),
      //   child: SafeArea(
      //     top: false,
      //     child: Row(
      //       children: [
      //         // Start Button (Host) - Pink like in image
      //         Expanded(
      //           flex: 2,
      //           child: SizedBox(
      //             height: 56,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 _showHostOptions(context);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: const Color(0xFFE91E63), // Pink
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(28),
      //                 ),
      //                 elevation: 2,
      //                 padding: const EdgeInsets.symmetric(horizontal: 12),
      //               ),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: const [
      //                   Icon(Icons.play_arrow, color: Colors.white, size: 28),
      //                   SizedBox(height: 4),
      //                   Text(
      //                     'Start',
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.white,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //         
      //         const SizedBox(width: 12),
      //         
      //         // Deelnemen Button (Join) - Light grey like in image
      //         Expanded(
      //           flex: 3,
      //           child: SizedBox(
      //             height: 56,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 _showJoinOptions(context);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: const Color(0xFFE8E8E8), // Light grey
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(28),
      //                 ),
      //                 elevation: 2,
      //                 padding: const EdgeInsets.symmetric(horizontal: 12),
      //               ),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: const [
      //                   Icon(Icons.groups, color: Colors.black, size: 22),
      //                   SizedBox(height: 4),
      //                   Text(
      //                     'Deelnemen',
      //                     style: TextStyle(
      //                       fontSize: 15,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.black,
      //                     ),
      //                     overflow: TextOverflow.ellipsis,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //         
      //         const SizedBox(width: 12),
      //         
      //         // QR Scan Button - matching the image style
      //         Container(
      //           width: 56,
      //           height: 56,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFFE8E8E8), // Light grey to match
      //             borderRadius: BorderRadius.circular(28),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.1),
      //                 blurRadius: 2,
      //                 offset: const Offset(0, 1),
      //               ),
      //             ],
      //           ),
      //           child: IconButton(
      //             onPressed: () {
      //               Navigator.pushNamed(context, '/join-qr');
      //             },
      //             padding: EdgeInsets.zero,
      //             icon: const Icon(
      //               Icons.qr_code_scanner,
      //               color: Colors.black,
      //               size: 28,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildStoryCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {},
                  ),
                ),
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              
              // Title Container
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              
              // Play button - repositioned like in image
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8), // Light grey like in image
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Placeholder content
          Center(
            child: Icon(
              Icons.image_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          
          // Play button - matching the main card style
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStoryOptions(BuildContext context, String storyTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              storyTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // Host option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.games, color: Colors.white),
              ),
              title: const Text(
                'Spel hosten',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Start een nieuw spel als host'),
              onTap: () {
                print('Spel hosten tapped');
                Navigator.pop(modalContext); // Close modal
                print('Modal closed, navigating to /host-share');
                Navigator.pushNamed(context, '/host-share'); // Use parent context
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHostOptions(BuildContext context) {
    // Show available stories to host
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kies een verhaal om te hosten',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.skateboarding, color: Colors.white),
              ),
              title: const Text(
                'HET SKATEPARK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('1e verhaal'),
              onTap: () {
                Navigator.pop(modalContext); // Close modal
                Navigator.pushNamed(context, '/host-share'); // Use parent context
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Deelnemen aan spel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // PIN option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.pin, color: Colors.white),
              ),
              title: const Text(
                'PIN invoeren',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Voer een 4-cijferige PIN in'),
              onTap: () {
                Navigator.pop(modalContext); // Close modal
                Navigator.pushNamed(context, '/join-pin'); // Use parent context
              },
            ),
            
            const Divider(),
            
            // QR option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E7E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white),
              ),
              title: const Text(
                'QR-code scannen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Scan de QR-code van de host'),
              onTap: () {
                Navigator.pop(modalContext); // Close modal
                Navigator.pushNamed(context, '/join-qr'); // Use parent context
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createGame(BuildContext context, String storyTitle) {
    print('Creating game with story: $storyTitle');
    
    // Navigate to host name entry screen via route
    Navigator.pushNamed(
      context,
      '/create-join',
      arguments: {
        'storyTitle': storyTitle,
      },
    ).then((value) {
      print('Returned from host name entry');
    }).catchError((error) {
      print('Navigation error: $error');
    });
  }
}