import 'package:fab/screens/journeyPlayScreen.dart';
import 'package:flutter/material.dart';

class AddJourneyTile extends StatelessWidget {
  const AddJourneyTile({
    super.key,
    required this.tile,
    required this.email,
  });

  final Map<String, dynamic> tile;
  final String email;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Extract data from tile
    final String url = tile['topDecoImageUrl'] ?? 'assets/images/default.jpg';
    final String title = tile['title'] ?? 'No Title';
    final String subtitle = tile['subtitle'] ?? 'No Subtitle';
    final String timestamp = tile['timestamp']?.toString() ?? '0';

    return GestureDetector(
      onTap: () {
        // Navigate to the JourneyPlayScreen with email and tile data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Journeyplayscreen(
              email: email,
              data: tile, // Pass the tile data if needed
            ),
          ),
        );
      },
      child: Stack(
        children: [
          // Background Image Container
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.03),
            height: screenHeight * 0.2,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlaying Title, Subtitle, Info Icon, and Percentage Text
          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.02,
            right: screenWidth * 0.07,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Icon at top right
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: screenWidth * 0.08,
                    ),
                    onPressed: () {
                      // Handle info icon tap if needed
                    },
                  ),
                ),

                // Title Text
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.015),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subtitle Text
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Percentage Text
          Positioned(
            right: 10,
            bottom: screenHeight * 0.02,
            child: Text(
              "$timestamp%", // Dynamically show timestamp as percentage
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}