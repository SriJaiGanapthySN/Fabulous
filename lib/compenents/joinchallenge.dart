import 'package:flutter/material.dart';

class JoinchallengeHeader extends StatelessWidget {
  const JoinchallengeHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(255, 15, 138, 138),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
