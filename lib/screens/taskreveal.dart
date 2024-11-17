import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Taskreveal extends StatefulWidget {
  const Taskreveal({super.key});

  @override
  State<Taskreveal> createState() => _TaskrevealState();
}

class _TaskrevealState extends State<Taskreveal> {
  bool _isAnimationVisible = false;

  void _onCheckPressed() {
    setState(() {
      _isAnimationVisible = true;
    });

    // Wait for the animation to play before navigating
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Main Lottie animation
          Lottie.asset(
            'assets/animations/breakfast.json',
            fit: BoxFit.cover,
            repeat: true,
            reverse: false,
            animate: true,
          ),
          // Task title
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Eat a Great Breakfast",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Content and buttons
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 440, left: 20, right: 20),
              child: Column(
                children: [
                  // Description
                  Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(69, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Breakfast provides you with the energy and nutrients you need to increase concentration in the classroom and at work. After all, it's the most important meal of the day.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Action buttons
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    alignment: Alignment.center,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(69, 0, 0, 0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        const Text(
                          "Today",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Skip button
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "Skip",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            // Check button with animation trigger
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Ensure the animation has a fixed size
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Visibility(
                                    visible: _isAnimationVisible,
                                    child: Lottie.asset(
                                      'assets/animations/buttonanimation.json',
                                      repeat: false,
                                    ),
                                  ),
                                ),
                                // Button itself
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                  onPressed: _onCheckPressed,
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    shape: const CircleBorder(),
                                  ),
                                ),
                              ],
                            ),

                            // Snooze button
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.repeat,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "Snooze",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
