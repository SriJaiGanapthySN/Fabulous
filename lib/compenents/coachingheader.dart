import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "assets/images/sample3.jpg",
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Burnout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Forged from the fire of burnout Now rise from the ashes.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF002A73),
            padding: const EdgeInsets.symmetric(horizontal: 145, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(
            Icons.play_arrow,
            size: 35,
          ),
          label: const Text(
            "Play",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
