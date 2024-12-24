import 'package:flutter/material.dart';

class JourneyRevealType1 extends StatelessWidget {
  const JourneyRevealType1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_right_rounded,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 300, bottom: 30),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Journey Reveal Type 1'),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 162, 36, 27),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
