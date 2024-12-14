import 'package:fab/screens/routinelistscreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab/services/task_services.dart';
import 'package:audioplayers/audioplayers.dart';

class Taskreveal extends StatefulWidget {
  const Taskreveal({super.key});

  @override
  State<Taskreveal> createState() => _TaskrevealState();
}

class _TaskrevealState extends State<Taskreveal> {
  bool _isAnimationVisible = false;
  int _currentIndex = 0; // Track the current task
  bool _isSnoozed = false; // Track snooze state
  bool _isSkiped = false;  // Track if the task is skipped
  AudioPlayer _audioPlayer = AudioPlayer();  // Audio player instance

  @override
  void initState() {
    super.initState();
  }

  // Play audio if snooze is not active
  void _playAudio(String audioLink) async {
    if (!_isSnoozed) {
      await _audioPlayer.play(UrlSource(audioLink));
    }
  }

  // Stop the audio
  void _stopAudio() async {
    await _audioPlayer.stop();
  }

  // Handle task completion (check button press)
  void _onCheckPressed(String animationLink, String taskID) {
    setState(() {
      _isAnimationVisible = true;
    });

    // Update task status
    TaskServices().updateTaskStatus(true, taskID);

    // Play the animation
    Lottie.network(animationLink, repeat: false);

    // Move to the next task after the animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          _isAnimationVisible = false;
        });
      }
    });
  }

  // Handle skip button press
  void _onSkipPressed() {
    setState(() {
      _isSkiped = !_isSkiped;
    });

    // Move to the next task after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
          _isAnimationVisible = false;
        });
      }
    });
  }

  // Handle snooze button press
  void _onSnoozePressed() {
    setState(() {
      _isSnoozed = !_isSnoozed;
    });

    // Stop the audio when snooze is pressed
    _stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,  // Hide the app bar
      body: StreamBuilder<QuerySnapshot>(
        stream: TaskServices().getdailyTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var tasks = snapshot.data!.docs;

          // Navigate back when all tasks are completed
          if (_currentIndex >= tasks.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _stopAudio();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Routinelistscreen(),
                ),
              );
            });
            return SizedBox.shrink();
          }

          var currentTask = tasks[_currentIndex];

          // Play audio when background is shown
          if (!_isSnoozed) {
            _playAudio(currentTask['audioLink']);
          }

          // Stop audio when the last task's animation finishes
          if (_currentIndex == tasks.length - 1 && _isAnimationVisible) {
            _stopAudio();
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.network(
                  currentTask['backgroundLink'],
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    currentTask['name'] ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 440, left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(69, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          currentTask['descriptionHtml'] ?? '',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: _onSkipPressed,
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
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Visibility(
                                        visible: _isAnimationVisible,
                                        child: Lottie.network(
                                          currentTask['animationLink'],
                                          repeat: false,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 45,
                                      ),
                                      onPressed: () =>
                                          _onCheckPressed(currentTask['animationLink'], currentTask['objectID']),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.pink,
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: _onSnoozePressed,
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
          );
        },
      ),
    );
  }
}