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
  late AnimationController _mindcontroller;
  late AnimationController _ripplecontroller;
  late Animation<Color?> _colorAnimation;
  bool _isMessageBoxVisible = false;
  final FocusNode _focusNode = FocusNode();
  double _opacity = 0.0;
  bool _isLongPressing = false;
  String displayText = "Hold to Speak";
  late Timer _timer;
  bool _isReversing = false;
  bool _isRippleDone = false;
  // bool _repeatGlow = true;

  late AnimationController _boxAnimationController;
  late AnimationController _glowAnimationController;

  // Ensure initialization of animationController in initState
  late AnimationController _animationController;

  final String sentence =
      "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.";

  @override
  void initState() {
    super.initState();

    // _mindcontroller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 5), // Sets animation duration to 2 seconds
    // )..repeat(reverse: false);

    _mindcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Smooth duration
    )..addListener(() {
        if (_mindcontroller.value > 0.99 && !_isReversing) {
          // Start reversing at 90% progress
          _isReversing = true;
          _mindcontroller.reverse();
        } else if (_mindcontroller.value < 0.13 && _isReversing) {
          // Start playing forward again at 10% progress
          _isReversing = false;
          _mindcontroller.forward();
        }
      });

    _mindcontroller.forward(); // Start animation forward

    _ripplecontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Sets animation duration to 2 seconds
    )..repeat(reverse: false);
    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // _ripplecontroller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 4), // Smooth duration
    // )..addListener(() {
    //   _ripplecontroller.forward();
    //     if (_ripplecontroller.value > 0.90) {
    //       // When animation reaches 90%, reset it to 10% and keep running
    //       // _ripplecontroller.forward();
    //       // _ripplecontroller.reset();  // Reset to beginning

    //       _ripplecontroller.value = 0.1;
    //       _ripplecontroller.forward(); // Restart smoothly
    //     }else{
    //        _ripplecontroller.forward();
    //     }
    //   });

    // _ripplecontroller.forward(); // Start animation

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

    int textDurationMs = (sentence.length * 10) +
        800; // Character delay (10ms) + full effect (800ms)
    Duration textAnimationDuration = Duration(milliseconds: textDurationMs);

    // Box animation controller (duration matches text animation)
    // _boxAnimationController = AnimationController(
    //   vsync: this,
    //   duration: textAnimationDuration,
    // );

    _boxAnimationController = AnimationController(
      vsync: this,
      duration: textAnimationDuration,
    );

    // Glow animation controller (matches box animation)
    _glowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _boxAnimationController.forward();
    _glowAnimationController.forward();

    // Future.delayed(Duration(seconds: 5), () {
    //   setState(() {
    //     _repeatGlow = false; // Stop repeating after 5 seconds
    //   });
    // });
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
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 5, horizontal: 10),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Container(
                      //       constraints: BoxConstraints(
                      //           maxWidth:
                      //               MediaQuery.of(context).size.width * 0.7),
                      //       padding: const EdgeInsets.symmetric(
                      //           vertical: 12, horizontal: 18),
                      //       decoration: BoxDecoration(
                      //         color: colorAnimation.value,
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       child: Column(
                      //         children: [
                      //           TextAnimator(
                      //             "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.",
                      //             incomingEffect: WidgetTransitionEffects(
                      //                 blur: const Offset(10, 10),
                      //                 duration:
                      //                     const Duration(milliseconds: 800)),
                      //             outgoingEffect: WidgetTransitionEffects(
                      //                 blur: const Offset(10, 10)),
                      //             atRestEffect: WidgetRestingEffects.wave(
                      //                 effectStrength: 0.2,
                      //                 duration: Duration(milliseconds: 750),
                      //                 numberOfPlays: 1),
                      //             style: GoogleFonts.lato(
                      //                 textStyle: TextStyle(
                      //               fontFamily: "Original",
                      //               letterSpacing: 1,
                      //               fontSize: 14,
                      //               color: _colorAnimation.value ?? Colors.blue,
                      //             )),
                      //             textAlign: TextAlign.left,
                      //             initialDelay: const Duration(milliseconds: 0),
                      //             spaceDelay: const Duration(milliseconds: 100),
                      //             characterDelay:
                      //                 const Duration(milliseconds: 10),
                      //             maxLines: 3,
                      //           ),
                      //           AnimatedOpacity(
                      //             duration: Duration(seconds: 1),
                      //             opacity: iconOpacity,
                      //             curve: Curves.easeIn,
                      //             child: Row(
                      //               children: [
                      //                 IconButton(
                      //                   onPressed: () {},
                      //                   icon: FaIcon(
                      //                     FontAwesomeIcons.heart,
                      //                     color: Colors.white,
                      //                     size: 20,
                      //                   ),
                      //                 ),
                      //                 SizedBox(width: 5),
                      //                 IconButton(
                      //                   onPressed: () {},
                      //                   icon: FaIcon(
                      //                     FontAwesomeIcons.plus,
                      //                     color: Colors.white,
                      //                     size: 20,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // );

                      int textDurationMs = (sentence.length * 10) +
                          800; // Character delay (10ms) + full effect (800ms)
                      Duration textAnimationDuration =
                          Duration(milliseconds: textDurationMs);
                         bool repeatGlow=true;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: [
                              // Animated Lottie Box
                              Lottie.asset(
                                "assets/animations/Inner+Outerbox+Glow/Outerbox/Outerbox.json", // Replace with actual file path
                                width: MediaQuery.of(context).size.width *
                                    0.7, // Match previous maxWidth
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.fill,
                                controller: _boxAnimationController,
                                repeat: false,
                                // controller: _boxAnimationController, // Attach animation controller if needed
                              ),

                              Lottie.asset(
                                "assets/animations/Inner+Outerbox+Glow/Outer Glow/Outerbox.json", // Replace with actual file path
                                width: MediaQuery.of(context).size.width *
                                    0.7, // Match previous maxWidth
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.fill,
                                // controller: _glowAnimationController,
                                //  repeat: true,
                                // controller: _boxAnimationController, // Attach animation controller if needed
                                repeat: repeatGlow,
                                onLoaded: (composition) {
                                  // Timer starts ONLY when the animation first loads
                                  Future.delayed(textAnimationDuration, () {
                                    setState(() {
                                      repeatGlow =
                                          false; // Stop repeating after 5 seconds
                                    });
                                  });
                                },
                              ),

                              // Overlay text and icons inside the animated box
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextAnimator(
                                        "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.",
                                        incomingEffect: WidgetTransitionEffects(
                                            blur: const Offset(10, 10),
                                            duration: const Duration(
                                                milliseconds: 800)),
                                        outgoingEffect: WidgetTransitionEffects(
                                            blur: const Offset(10, 10)),
                                        atRestEffect: WidgetRestingEffects.wave(
                                            effectStrength: 0.2,
                                            duration:
                                                Duration(milliseconds: 750),
                                            numberOfPlays: 1),
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                          fontFamily: "Original",
                                          letterSpacing: 1,
                                          fontSize: 14,
                                          color: Colors
                                              .white, // Ensure text is visible over the animation
                                        )),
                                        textAlign: TextAlign.left,
                                        initialDelay:
                                            const Duration(milliseconds: 0),
                                        spaceDelay:
                                            const Duration(milliseconds: 100),
                                        characterDelay:
                                            const Duration(milliseconds: 10),
                                        maxLines: 3,
                                      ),

                                      // Icons Row with Fade-In Animation
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
                            ],
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
          Container(
            color: Color(0xFF1E1B8A), // Set your desired background color
            width: double.infinity,
            height: double.infinity,
          ),

          // Center(
          //   child: Lottie.asset(
          //     'assets/animations/BG small Blur/BG small Blur.json', // Replace with your actual Lottie file path
          //     width: 400, // Adjust size as needed
          //     height: 400,
          //     fit: BoxFit.contain,
          //     controller: _mindcontroller,
          //     // animate: true,
          //   ),
          // ),
          // Center(
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       // Lottie animation
          //       Lottie.asset(
          //         "assets/animations/Inner+Outerbox+Glow/Inner Box/Outerbox.json",
          //         width: 220, // 2x the height
          //         height: 100, // Base height
          //         fit: BoxFit.fill, // Ensures it stretches properly
          //         controller:
          //             _mindcontroller, // Using the same controller for the animation
          //         animate: true,
          //       ),

          //       // Animate the text based on the same controller
          //       // AnimatedBuilder(
          //       //   animation: _mindcontroller,
          //       //   builder: (context, child) {
          //       //     // We are fading in and out the text using the controller's value
          //       //     return Align(
          //       //       alignment: Alignment.center,
          //       //       child: Opacity(
          //       //         opacity: _mindcontroller
          //       //             .value, // Fade based on controller value
          //       //         child: Transform.translate(
          //       //           offset: Offset(0,
          //       //               -5), // Shift the text up by 20 pixels (adjust as needed)
          //       //           child: Text(
          //       //             "What's on your mind?",
          //       //             style: TextStyle(
          //       //               color: const Color.fromARGB(
          //       //                   206, 255, 255, 255), // White text color
          //       //               fontSize: 16, // Adjust size as needed
          //       //               fontWeight: FontWeight.w600, // Optional: bold text
          //       //             ),
          //       //           ),
          //       //         ),
          //       //       ),
          //       //     );
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),

          if (messages.isEmpty)
            Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/animations/BG small Blur/BG small Blur.json',
                    width: 400,
                    height: 400,
                    fit: BoxFit.contain,
                    controller: _mindcontroller,
                  ),
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        "assets/animations/Inner+Outerbox+Glow/Inner Box/Outerbox.json",
                        width: 220,
                        height: 100,
                        fit: BoxFit.fill,
                        controller: _mindcontroller,
                        animate: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

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
                            color: Colors.white12,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
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
                                  Icons.blur_circular,
                                  color: Colors.white,
                                  size: 45,
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
                        margin: EdgeInsets.only(left: 2),
                        child: AnimatedOpacity(
                          duration: Duration(
                              milliseconds:
                                  2000), // Smooth fade-in and fade-out
                          opacity: _opacity,
                          child: Row(
                            children: [
                              if (!_isLongPressing) ...[
                                Icon(
                                  Icons
                                      .circle_sharp, // Add the circle_sharp icon
                                  color: Color(0xFFA715E9), // Icon color
                                  size: 6, // Icon size
                                ),
                                SizedBox(
                                    width: 2), // Space between icon and text

                                TextAnimator(
                                  displayText,
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
                                  style: TextStyle(
                                      fontFamily: "Original",
                                      color: Colors.white,
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                  initialDelay: const Duration(milliseconds: 0),
                                  spaceDelay: const Duration(milliseconds: 100),
                                  characterDelay:
                                      const Duration(milliseconds: 10),
                                ),
                              ]
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
          if (_isLongPressing)
            Positioned(
              bottom: kBottomNavigationBarHeight + 45,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  "assets/animations/All Lottie/Down Ripple/Ripple.json", // Your local animation
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  fit: BoxFit.cover,
                  // controller: _ripplecontroller,
                  repeat: true, // Makes animation run continuously
                  animate: true, // Ensure animation starts
                  // onLoaded: (composition) {
                  //   _animationController
                  //     ..duration = composition.duration;
                  // },

                  controller: _ripplecontroller, // Use custom controller
                  // onLoaded: (composition) {
                  //   _ripplecontroller
                  //     ..duration = composition.duration * 2 // Slows down animation (2x duration)
                  //     ..repeat(reverse: true);  // Loops the animation
                  // },
                ),
              ),
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
