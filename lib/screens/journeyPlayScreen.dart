// import 'package:fab/services/journey_service.dart';
// import 'package:flutter/material.dart';

// class Journeyplayscreen extends StatelessWidget {
//   final String email;
//   final Map<String, dynamic> data;

//   const Journeyplayscreen({super.key, required this.email, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final JourneyService _journeyService = JourneyService();
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     // Extract data from the passed 'data' map
//     final String backgroundImage = data['bigImageUrl'] ?? 'https://via.placeholder.com/400';
//     final String title = data['title'] ?? 'No Title';
//     final String rawDescription = data['chapterDescription'] ?? 'No Description';
//     final String description = rawDescription.replaceAll('{{NAME}}', 'Rudraksh');
//     final String ctaColor=data['ctaColor'];

//     Color colorFromString(String colorString) {
//     try {
//       String hexColor = colorString.replaceAll('#', '');
//       if (hexColor.length == 6) {
//         return Color(int.parse('0xFF$hexColor'));
//       }
//     } catch (e) {
//       // Default to black if color string is invalid
//       return Colors.black;
//     }
//     throw FormatException('Invalid color string format');
//   }

//   void updateJourney(String email){
//     _journeyService.fetchUnreleaseJourney(email);
//   }

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             height: screenHeight,
//             width: screenWidth,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(backgroundImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // Dark overlay for better text visibility
//           Container(
//             height: screenHeight,
//             width: screenWidth,
//             color: Colors.black.withOpacity(0.4),
//           ),

//           // Content on top of the background
//           Positioned(
//             top: screenHeight * 0.20, // 20% from the top
//             left: screenWidth * 0.1,
//             right: screenWidth * 0.1,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.12, // Responsive font size
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 5,
//                         color: Colors.black54,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: screenHeight * 0.02), // Spacing

//                 // "in which" text
//                 Text(
//                   "In which",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.075,
//                     fontStyle: FontStyle.italic,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black54,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: screenHeight * 0.02), // Spacing

//                 // Description text
//                 Text(
//                   description,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.065,
//                     // fontWeight: FontWeight.w400,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black45,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Play Button at the bottom
//           Positioned(
//             bottom: screenHeight * 0.1, // 10% from the bottom
//             left: (screenWidth - screenWidth * 0.25) / 2, // Center horizontally
//             child: GestureDetector(
//               onTap: () {
//                 // Handle play button tap
//                 updateJourney(this.email);
//                 print('Play button tapped!');
//               },
//               child: Container(
//                 height: screenWidth * 0.45,
//                 width: screenWidth * 0.30,
//                 decoration: BoxDecoration(
//                   color: colorFromString(ctaColor),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.play_arrow,
//                   color: Colors.white,
//                   size: screenWidth * 0.20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fab/services/journey_service.dart';
import 'package:flutter/material.dart';

class Journeyplayscreen extends StatelessWidget {
  final String email;
  final Map<String, dynamic> data;

  const Journeyplayscreen({super.key, required this.email, required this.data});

  @override
  Widget build(BuildContext context) {
    final JourneyService _journeyService = JourneyService();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Extract data from the passed 'data' map
    final String backgroundImage =
        data['bigImageUrl'] ?? 'https://via.placeholder.com/400';
    final String title = data['title'] ?? 'No Title';
    final String rawDescription =
        data['chapterDescription'] ?? 'No Description';
    final String description =
        rawDescription.replaceAll('{{NAME}}', 'Rudraksh');
    final String ctaColor = data['ctaColor'] ?? '#FFA500'; // Default to orange
    final String objId = data['objectId'];

    /// Converts Hex String to Color
    Color colorFromString(String colorString) {
      try {
        String hexColor = colorString.replaceAll('#', '');
        if (hexColor.length == 6) {
          return Color(int.parse('0xFF$hexColor'));
        }
      } catch (e) {
        print("Invalid color string: $e");
      }
      return Colors.orange; // Default to orange on error
    }

    /// Fetches and updates the journey
    Future<void> updateJourney(String email) async {
      try {
        // Fetch unreleased journey
        final data = await _journeyService.fetchUnreleaseJourney(email);

        if (data != null) {
          // Extract document ID properly
          final String docId = data['objectId'];

          // Update the isReleased field
          await _journeyService.updateIsReleased(email, docId);

          print('Journey updated!');
        } else {
          print('No unreleased journey found.');
        }
        await _journeyService.addSkillTrack(objId, email);
        final skills = await _journeyService.addSkills(objId, email);
        if (skills.isNotEmpty) {
          final goals = await _journeyService.addSkillLevel(skills, email);
          print('Skill levels added!');
          if (goals.isNotEmpty) {
            await _journeyService.addSkillGoals(goals, email);
            print('Goals added!');
          } else {
            print('No goals found to add .');
          }
        } else {
          print('No skills found to add levels.');
        }
      } catch (e) {
        print('Error updating journey: $e');
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay for better text visibility
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.black.withOpacity(0.4),
          ),

          // Content: Title, "In Which", Description
          Positioned(
            top: screenHeight * 0.20, // 20% from the top
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.12,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // "In which" text
                Text(
                  "In which",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.075,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Description text
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Play Button
          Positioned(
            bottom: screenHeight * 0.1, // 10% from the bottom
            left: (screenWidth - screenWidth * 0.25) / 2, // Center horizontally
            child: GestureDetector(
              onTap: () async {
                await updateJourney(email);
                print('Play button tapped!');
              },
              child: Container(
                height: screenWidth * 0.25,
                width: screenWidth * 0.25,
                decoration: BoxDecoration(
                  color: colorFromString(ctaColor),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: screenWidth * 0.15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
