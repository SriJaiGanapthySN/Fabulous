import 'package:flutter/material.dart';

class Journeyscreentype3 extends StatelessWidget {
  const Journeyscreentype3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/sample3.jpg',
            fit: BoxFit.cover,
            height: 200,
          ),
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Text('Journeyscreentype3',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16),
          Text(
            "Caption",
            style: TextStyle(fontSize: 26),
          ),
          SizedBox(height: 480),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 13, 173, 32),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Done! What Next',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
