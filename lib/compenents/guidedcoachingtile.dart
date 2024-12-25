import 'package:flutter/material.dart';

class Guidedcoachingtile extends StatelessWidget {
  const Guidedcoachingtile(
      {super.key,
      required this.url,
      required this.title,
      required this.timestamp});
  final String url;
  final String title;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 300, top: 20),
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(120, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                timestamp,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, top: 10),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
