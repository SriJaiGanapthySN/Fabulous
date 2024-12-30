import 'package:fab/compenents/mygridtile.dart';
import 'package:flutter/material.dart';

class Guidedcoachingmenu extends StatelessWidget {
  const Guidedcoachingmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Guides',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            Mygridtile(url: "assets/images/login.jpg", title: "Exercise"),
            Mygridtile(url: "assets/images/sample.jpg", title: "Meditation"),
            Mygridtile(url: "assets/images/sample2.jpg", title: "Yoga"),
            Mygridtile(url: "assets/images/sample3.jpg", title: "Diet"),
          ],
        ));
  }
}
