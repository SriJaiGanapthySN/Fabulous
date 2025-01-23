import 'package:fab/compenents/coachingheader.dart';
import 'package:flutter/material.dart';
import '../compenents/contentcard.dart';

class Coachingscreenreveal extends StatelessWidget {
  const Coachingscreenreveal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002A73),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002A73),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            const SizedBox(height: 24),
            ContentCard(
              title: "Listen to the silence, it has so much to say",
              duration: "4 min",
              type: "Video",
            ),
            const SizedBox(height: 16),
            ContentCard(
              title: "Find your own center of gravity",
              duration: "3 min",
              type: "Audio",
            ),
            ContentCard(
              title: "Find your own center of gravity",
              duration: "3 min",
              type: "Audio",
            ),
          ],
        ),
      ),
    );
  }
}
