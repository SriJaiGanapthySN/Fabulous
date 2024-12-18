import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PlayAudio extends StatefulWidget {
  const PlayAudio({super.key});

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  void toggle() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _playSound() async {
    try {
      await audioPlayer.play(AssetSource('audio/sample.m4a'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _stopSound() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      print("Error stopping sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: SizedBox(
              height: 30,
              width: 100,
              child: ElevatedButton.icon(
                onPressed: () {},
                label: Text(
                  "Off",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 97, 96, 96),
                  ),
                ),
                icon: Icon(Icons.notifications_off),
                style: ElevatedButton.styleFrom(
                  elevation: 0.5,
                  backgroundColor: const Color.fromARGB(255, 244, 234, 234),
                  iconColor: const Color.fromARGB(255, 97, 96, 96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Container(
                height: 120,
                width: 400,
                child: Lottie.asset('assets/animations/audio.json')),
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 35,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 2),
                        trackShape: RoundedRectSliderTrackShape(),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: SizedBox(
                          width: 300,
                          child: Slider(
                            activeColor: const Color.fromARGB(255, 97, 96, 96),
                            inactiveColor:
                                const Color.fromARGB(255, 229, 227, 227),
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) {
                              final newPosition =
                                  Duration(seconds: value.toInt());
                              audioPlayer.seek(newPosition);
                              audioPlayer.resume();
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: Text(
                        "-${formatTime((duration - position).inSeconds)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 203, 199, 199),
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color.fromARGB(255, 229, 227, 227),
                  child: IconButton(
                      onPressed: () {
                        if (!isPlaying) {
                          _playSound();
                          toggle();
                        } else {
                          _stopSound();
                          toggle();
                        }
                      },
                      icon: isPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow)),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 26,
                        ))),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 270,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text(
                      "Add to Morning Routine",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                color: const Color.fromARGB(255, 229, 227, 227),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Lyrics",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}
