import 'package:flutter/material.dart';

class Guidedcoachingrevealscreen extends StatefulWidget {
  const Guidedcoachingrevealscreen({super.key});

  @override
  _Guidedcoachingrevealscreen createState() {
    return _Guidedcoachingrevealscreen();
  }
}

class _Guidedcoachingrevealscreen extends State<Guidedcoachingrevealscreen> {
  int currentStep = 0;
  bool isPlaying = false;

  final List<Map<String, String>> exercises = [
    {"name": "Jumping Jacks", "time": "30s"},
    {"name": "Breathe", "time": "10s"},
    {"name": "Push-ups", "time": "20s"},
  ];

  void nextStep() {
    setState(() {
      if (currentStep < exercises.length - 1) {
        currentStep++;
      }
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  void toggle() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            if (isPlaying)
              Container(
                margin: EdgeInsets.only(left: 40),
                alignment: Alignment.topLeft,
                child: Text("7-MIN\nWorkout",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold)),
              ),
            Container(
              margin: EdgeInsets.only(
                  top: isPlaying ? 350 : 500, left: isPlaying ? 0 : 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: isPlaying ? 50 : 40,
                    backgroundColor: isPlaying
                        ? const Color.fromARGB(255, 31, 203, 203)
                        : Colors.pink,
                    child: IconButton(
                        onPressed: () {
                          toggle();
                        },
                        icon: isPlaying
                            ? Icon(Icons.play_arrow,
                                color: Colors.white, size: 50)
                            : Icon(Icons.pause, color: Colors.white, size: 40)),
                  ),
                  if (!isPlaying)
                    IconButton(
                      icon: const Icon(Icons.skip_next,
                          color: Colors.white, size: 40),
                      onPressed: () {},
                    ),
                ],
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;

                  final isActive = index == currentStep;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        nextStep();
                      },
                      onDoubleTap: () {
                        previousStep();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exercise['name'] ?? '',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.white54,
                              fontSize: 25,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            exercise['time'] ?? '',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.white54,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
          ],
        )
      ],
    ));
  }
}
