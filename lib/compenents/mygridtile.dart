import 'package:flutter/material.dart';

class Mygridtile extends StatelessWidget {
  const Mygridtile({super.key, required this.url, required this.title});
  final String url;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(url),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
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
