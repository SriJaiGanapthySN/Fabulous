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
  late AnimationController _rippleController;
  late AnimationController _mindboxcontroller;
  late Animation<Color?> _colorAnimation;
  bool _isMessageBoxVisible = false;
  final FocusNode _focusNode = FocusNode();
  double _opacity = 0.0;
  bool _isLongPressing = false;
  String displayText = "Hold to Speak";
  late Timer _timer;
  bool _isReversing = false;
  bool _isRippleDone = false;
  bool _showContainer = false; // Initially hidden
  double _scale = 0.0; // Start with zero scale
  bool _isSendingMessage = false; // Add this variable
  bool _isGlowVisible = false;

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

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showContainer = true;
        _scale = 1.0; // Scale up to full size
      });
    });

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

    _mindboxcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Sets animation duration to 2 seconds
    )..repeat(); // Loops the animation

    // _ripplecontroller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 6), // Sets animation duration to 2 seconds
    // )..repeat();
    // _ripplecontroller.forward();
    _rippleController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 5), // Set animation duration to 6 seconds
    )..repeat();
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
    _rippleController.dispose();
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

      // setState(() {
      //   _isSendingMessage = true; // Set to true when sending message
      // });

      setState(() {
        Future.delayed(Duration(milliseconds: 10), () {
          _isSendingMessage = true;
          _isGlowVisible = true;
        });

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
                      int textDurationMs = (sentence.length * 10) +
                          800; // Character delay (10ms) + full effect (800ms)
                      Duration textAnimationDuration =
                          Duration(milliseconds: textDurationMs);
                      bool repeatGlow = true;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF1E1B8A),
            width: double.infinity,
            height: double.infinity,
          ),

          // Lottie Animation (Only Visible When Sending)
          Stack(
            children: [
              Visibility(
                visible: _isSendingMessage,
                child: Lottie.asset(
                  'assets/animations/All Lottie/BG Glow Gradient/3 in 1/BG Glow Gradient.json',
                  width: screenWidth,
                  height: screenHeight,
                  fit: BoxFit.cover,
                  repeat: false,
                  onLoaded: (composition) {
                    // Instantly turn off animation after it plays
                    Future.delayed(
                        composition.duration + Duration(milliseconds: 90), () {
                      setState(() {
                        _isSendingMessage = false;
                      });
                    });
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 10,
                child: Visibility(
                  visible: _isGlowVisible,
                  child: Lottie.asset(
                    'assets/animations/All Lottie/Glowing Star/Image Preload Gradient.json',
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.3,
                    fit: BoxFit.cover,
                    repeat: false,
                    onLoaded: (composition) {
                      // After 1-2 seconds, hide the glowing effect
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          _isGlowVisible = false;
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          if (messages.isEmpty)
            Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/animations/BG small Blur/BG small Blur.json',
                    width: screenWidth / 0.9,
                    height: screenHeight / 1.8,
                    fit: BoxFit.fill,
                    controller: _mindcontroller,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: _showContainer ? 1.0 : 0.0, // Fade in
                    duration: Duration(seconds: 1), // 1 sec fade-in
                    curve: Curves.easeInOut, // Smooth transition

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: screenWidth / 2.15,
                        height: screenHeight / 13,
                        color:
                            Colors.white.withOpacity(0.1), // Semi-transparent
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center, // Center the text
                        child: Text(
                          "What's on your mind?",
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.7), // Light white text
                            fontSize: screenWidth * 0.038, // Adjust size
                            fontWeight: FontWeight.w600, // Semi-bold
                          ),
                        ),
                      ),
                    ),
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
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      "assets/animations/All Lottie/Down Ripple/Ripple.json",
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight * 0.25,
                      fit: BoxFit.fill,
                      repeat: true,
                      animate: true,
                      // frameRate: FrameRate(30),
                      // controller:
                      //     _rippleController, // Custom controller for speed control
                      // onLoaded: (composition) {
                      //   _rippleController
                      //     ..duration = const Duration(
                      //         seconds: 6) // Set animation duration
                      //     ..forward(); // Start animation
                      // },
                    ),
                    Positioned(
                      bottom: screenHeight * 0.06,
                      left:
                          16, // Add left padding to keep text within the screen
                      right:
                          16, // Add right padding to keep text within the screen
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust width dynamically
                        child: TextAnimator(
                          "I'm feeling burned out. Any suggestions for recharging?",
                          incomingEffect: WidgetTransitionEffects
                              .incomingSlideInFromBottom(),
                          outgoingEffect: WidgetTransitionEffects
                              .outgoingSlideOutToBottom(),
                          atRestEffect: WidgetRestingEffects.wave(
                              numberOfPlays: 1, effectStrength: 0.2),
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          // Synchronize with Lottie by delaying initial text appearance
                          initialDelay: const Duration(
                              milliseconds: 100), // Reduced initial delay
                          spaceDelay: const Duration(
                              milliseconds: 50), // Faster space delay
                          characterDelay: const Duration(
                              milliseconds:
                                  20), // Slightly faster character delay
                          maxLines: 3,
                        ),
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
