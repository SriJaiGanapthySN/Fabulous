import 'package:fab/compenents/custombutton.dart';
import 'package:fab/compenents/custombuttondiscover.dart';
import 'package:fab/screens/addJourneyScreen.dart';
import 'package:fab/screens/challengesscreen.dart';
import 'package:fab/screens/guidedcoachingmenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Discoverscreen extends StatelessWidget {
  final String email;
  const Discoverscreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = (screenWidth / 2) - 20;  // Dynamic width with padding

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discover",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.gift),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.instagram),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomButtonDiscover(
                    url: "assets/images/RoutinesList.png",
                    routineName: "Journeys",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddJourneyScreen(email: email),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButtonDiscover(
                    url: "assets/images/RoutinesList.png",
                    routineName: "Guided Activities",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Guidedcoachingmenu(email: email),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomButtonDiscover(
                    url: "assets/images/RoutinesList.png",
                    routineName: "Challenges",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Challengesscreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButtonDiscover(
                    url: "assets/images/RoutinesList.png",
                    routineName: "Coaching Series",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}