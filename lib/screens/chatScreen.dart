import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ChatScreen extends StatefulWidget {
  final String email;

  const ChatScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Widget> messages = [];
  final TextEditingController _controller = TextEditingController();
  late VideoPlayerController _videoController;
  late AnimationController _ccontroller;
  late Animation<Color?> _colorAnimation;
  bool _isMessageBoxVisible = false;
  final FocusNode _focusNode = FocusNode();
  double _opacity = 0.0;
  bool _isLongPressing = false;
  String displayText = "Hold to Speak";
  late Timer _timer;

  // Ensure initialization of animationController in initState
  late AnimationController _animationController;

  final String sentence =
      "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.";

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/videos/chatBg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });

    _ccontroller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.white,
    ).animate(_ccontroller);
    _ccontroller.forward();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    _startTextSwitching();
  }

  void _startTextSwitching() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        displayText =
            (displayText == "Hold to Speak") ? "Tap to Chat" : "Hold to Speak";
        // Toggle opacity
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose(); // Dispose of the animation controller
    super.dispose();
    _ccontroller.dispose();
    _timer.cancel();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressing = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isLongPressing = false;
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final String messageText = _controller.text;
      _controller.clear();

      // Create an animation controller for the user's message animation
      AnimationController animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );

      Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(-1.5, 19), // Start from the bottom
        end: Offset.zero, // End at its position
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ));

      setState(() {
        messages.add(
          AnimatedMessageBubble(
            message: messageText,
            alignment: Alignment.centerRight,
            animation: slideAnimation,
            controller: animationController,
            bubbleColor: Colors.white,
            textColor: Colors.black,
          ),
        );
      });

      animationController.forward();

      // After the user's message animation completes, show the reply
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          AnimationController replyController = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 10),
          );

          Animation<Color?> colorAnimation = TweenSequence<Color?>(
            [
              TweenSequenceItem(
                tween: ColorTween(begin: Colors.white10, end: Colors.white30)
                    .chain(CurveTween(curve: Curves.easeIn)),
                weight: 50.0,
              ),
              TweenSequenceItem(
                tween: ColorTween(begin: Colors.white30, end: Colors.white10)
                    .chain(CurveTween(curve: Curves.easeOut)),
                weight: 50.0,
              ),
            ],
          ).animate(replyController);

          double iconOpacity = 0.0; // Initial opacity of icons

          setState(() {
            messages.add(
              StatefulBuilder(
                builder: (context, setLocalState) {
                  Future.delayed(Duration(seconds: 5), () {
                    setLocalState(() {
                      iconOpacity = 1.0; // Change opacity after 3 seconds
                    });
                  });

                  return AnimatedBuilder(
                    animation: colorAnimation,
                    builder: (context, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
                            decoration: BoxDecoration(
                              color: colorAnimation.value,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                TextAnimator(
                                  "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.",
                                  incomingEffect: WidgetTransitionEffects(
                                      blur: const Offset(10, 10),
                                      duration:
                                          const Duration(milliseconds: 500)),
                                  outgoingEffect: WidgetTransitionEffects(
                                      blur: const Offset(10, 10)),
                                  atRestEffect: WidgetRestingEffects.wave(
                                      effectStrength: 0.2,
                                      duration: Duration(milliseconds: 750),
                                      numberOfPlays: 1),
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                    fontFamily: "Original",
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    color: _colorAnimation.value ?? Colors.blue,
                                  )),
                                  textAlign: TextAlign.left,
                                  initialDelay: const Duration(milliseconds: 0),
                                  spaceDelay: const Duration(milliseconds: 100),
                                  characterDelay:
                                      const Duration(milliseconds: 10),
                                  maxLines: 3,
                                ),
                                AnimatedOpacity(
                                  duration: Duration(seconds: 1),
                                  opacity: iconOpacity,
                                  curve: Curves.easeIn,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: FaIcon(
                                          FontAwesomeIcons.heart,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      IconButton(
                                        onPressed: () {},
                                        icon: FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          });

          replyController.forward();
        }
      });
    }
  }

  void _toggleMessageBoxVisibility() {
    setState(() {
      _isMessageBoxVisible = !_isMessageBoxVisible;
    });

    // Set focus to the TextField when the message box is visible
    if (_isMessageBoxVisible) {
      Future.delayed(const Duration(milliseconds: 10), () {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else {
      // Remove focus and close the keyboard when the message box is hidden
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background video
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          // Chat overlay
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index]; // Normal top-to-bottom flow
                  },
                ),
              ),
              // Bottom row with toggle button, message input box, and send button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // Toggle button
                    GestureDetector(
                      onTap: _toggleMessageBoxVisibility,
                      onLongPressStart: _onLongPressStart,
                      onLongPressEnd: _onLongPressEnd,
                      onLongPressDown: (_) {},
                      onLongPressUp: () {},
                      child: Container(
                          width: 56, // Button size
                          height: 56, // Button size
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _isMessageBoxVisible || _isLongPressing
                              ? Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.message,
                                  color: Colors.white,
                                )
                          // : Container(
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(54)),
                          //     child: Image.asset(
                          //       "assets/images/icon.png",
                          //       height: 10,
                          //       width: 10,
                          //     ),
                          //   ),
                          ),
                    ),
                    const SizedBox(
                        width:
                            8), // Spacing between toggle button and input box
                    // Long press animation at the bottom of the screen
                    if (_isLongPressing)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Lottie.asset(
                              'assets/animations/Ripple.json', // Your local animation
                              width: 100,
                              height: 100,
                              controller: _animationController,
                              onLoaded: (composition) {
                                _animationController
                                  ..duration = composition.duration;
                              },
                            ),
                          ),
                        ),
                      ),
                    // Message input box
                    if (_isMessageBoxVisible)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.white10, // Semi-transparent background
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Shadow offset
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode, // Assign the FocusNode
                            maxLines: null, // Allow multiple lines
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                color: Colors.white), // Set text color to white
                            decoration: InputDecoration(
                              hintText: "Message",
                              hintStyle: const TextStyle(
                                  color: Colors.white70), // Hint text color
                              border: InputBorder.none, // Remove border
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                        width: 8), // Spacing between input box and send button
                    // Send button
                    if (_isMessageBoxVisible)
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        color: Colors.white54, // Set icon color to white
                      ),
                    if (!_isMessageBoxVisible)
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: AnimatedOpacity(
                          duration: Duration(
                              milliseconds:
                                  2000), // Smooth fade-in and fade-out
                          opacity: _opacity,
                          child: TextAnimator(
                            displayText,
                            incomingEffect: WidgetTransitionEffects(
                                blur: const Offset(10, 10),
                                duration: const Duration(milliseconds: 500)),
                            outgoingEffect: WidgetTransitionEffects(
                                blur: const Offset(10, 10)),
                            atRestEffect: WidgetRestingEffects.wave(
                                effectStrength: 0.2,
                                duration: Duration(milliseconds: 750),
                                numberOfPlays: 1),
                            style: TextStyle(
                                fontFamily: "Original",
                                color: Colors.white,
                                fontSize: 18),
                            textAlign: TextAlign.left,
                            initialDelay: const Duration(milliseconds: 0),
                            spaceDelay: const Duration(milliseconds: 100),
                            characterDelay: const Duration(milliseconds: 10),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedMessageBubble extends StatelessWidget {
  final String message;
  final Alignment alignment;
  final Animation<Offset> animation;
  final AnimationController controller;
  final Color bubbleColor;
  final Color textColor;

  const AnimatedMessageBubble({
    Key? key,
    required this.message,
    required this.alignment,
    required this.animation,
    required this.controller,
    required this.bubbleColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Align(
          alignment: alignment,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              message,
              style: TextStyle(color: textColor),
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}
