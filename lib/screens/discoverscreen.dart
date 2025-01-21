import 'package:fab/compenents/custombuttondiscover.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Discoverscreen extends StatelessWidget {
  const Discoverscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.gift),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.instagram),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              CustomButtonDiscover(
                URL: "assets/images/RoutinesList.png",
                routineName: "Journeys",
              ),
              CustomButtonDiscover(
                URL: "assets/images/RoutinesList.png",
                routineName: "Guided Activities",
              ),
            ],
          ),
          Row(
            children: [
              CustomButtonDiscover(
                URL: "assets/images/RoutinesList.png",
                routineName: "Challenges",
              ),
              CustomButtonDiscover(
                URL: "assets/images/RoutinesList.png",
                routineName: "Coaching Series",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
