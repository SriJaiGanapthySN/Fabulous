import 'package:flutter/material.dart';

class Challengesgridtile extends StatelessWidget {
  const Challengesgridtile({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 110,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(url),
                fit: BoxFit.cover,
                alignment: Alignment.center),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                color: const Color.fromARGB(255, 228, 190, 22),
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
