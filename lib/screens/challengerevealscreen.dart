import 'package:fab/compenents/challengereveal.dart';
import 'package:flutter/material.dart';

class Challengerevealscreen extends StatefulWidget {
  const Challengerevealscreen({super.key});

  @override
  State<Challengerevealscreen> createState() => _ChallengerevealscreenState();
}

class _ChallengerevealscreenState extends State<Challengerevealscreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Challengereveal(
          url: 'assets/images/meditation.jpg',
          appbartext: 'Fabulous Challenge',
        ),
      ],
    );
  }
}
