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
  bool isThresholdReached = false; // Variable to track state change

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
  String voicetext = "I'm feeling burned out. Any suggestions for recharging?";
  bool _shouldShowTextBox = false;
  bool _showMindText = true; // Add this variable to control text visibility

  // bool _repeatGlow = true;

  late AnimationController _boxAnimationController;
  late AnimationController _glowAnimationController;

  // Ensure initialization of animationController in initState
  late AnimationController _animationController;

  final String sentence =
      "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits. ";

  // Add this ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

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
        setState(() {
          _shouldShowTextBox = true; // Show second box when animation starts
        });
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

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Back to original 5 seconds
    )..repeat();
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

    int textDurationMs = (sentence.length * 10) +
        800; // Character delay (10ms) + full effect (800ms)
    Duration textAnimationDuration = Duration(milliseconds: textDurationMs);

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

    // Add a listener to the text controller
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && _showMindText) {
        setState(() {
          _showMindText = false;
          _shouldShowTextBox = false;
          _mindcontroller.stop();
        });
      } else if (_controller.text.isEmpty &&
          !_showMindText &&
          _isMessageBoxVisible) {
        setState(() {
          _showMindText = true;
          _shouldShowTextBox = true;
          _mindcontroller.reset();
          _mindcontroller.forward();
        });
      }
    });
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
    _scrollController.dispose(); // Add this line
    super.dispose();
    _ccontroller.dispose();
    _timer.cancel();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressing = true;
      // Fade out both the text and background when long pressing
      _showMindText = false;
      _shouldShowTextBox = false;
      _mindcontroller.stop();
      // Reset and restart the ripple animation
      _rippleController.reset();
      _rippleController.forward();
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _sendMessage(sentence);
      _isLongPressing = false;
      _showMindText = true;
      _shouldShowTextBox = true;
      _mindcontroller.reset();
      _mindcontroller.forward();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String response) {
    if (true) {
      final String messageText =
          !_controller.text.isEmpty ? _controller.text : voicetext;
      _controller.clear();

      // Create an animation controller for the user's message animation
      AnimationController animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );

      Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ));

      setState(() {
        Future.delayed(Duration(milliseconds: 0), () {
          _isSendingMessage = true;
        });

        messages.insert(
            0,
            AnimatedMessageBubble(
              message: messageText,
              alignment: Alignment.centerRight,
              animation: slideAnimation,
              controller: animationController,
              bubbleColor: Colors.white,
              textColor: Colors.black,
            ));
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
          bool repeatGlow = true;
          bool _isGlowVisible = true;
          bool _isBoxVisible = false;
          int textDurationMs = (response.length * 10) +
              800; // Character delay (10ms) + full effect (800ms)
          Duration textAnimationDuration =
              Duration(milliseconds: textDurationMs + 1000);

          setState(() {
            messages.insert(
              0,
              StatefulBuilder(
                builder: (context, setLocalState) {
                  bool hasShownGradient = false; // Add this flag

                  Future.delayed(Duration(milliseconds: 2000), () {
                    setLocalState(() {
                      _isBoxVisible = true;
                      _isGlowVisible =
                          !hasShownGradient; // Only show if not shown before
                    });

                    // Add this to hide the glow after one animation
                    Future.delayed(Duration(milliseconds: 800), () {
                      setLocalState(() {
                        _isGlowVisible = false;
                        hasShownGradient = true; // Mark as shown
                      });
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
                          child: Stack(
                            children: [
                              // Only show gradient animation if not shown before
                              if (!hasShownGradient)
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 800),
                                  opacity: !_isGlowVisible ? 0.0 : 1.0,
                                  child: Lottie.asset(
                                    'assets/animations/All Lottie/Glowing Star/Image Preload Gradient.json',
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    fit: BoxFit.cover,
                                    repeat: false,
                                    onLoaded: (composition) {
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        setLocalState(() {
                                          _isGlowVisible = false;
                                          hasShownGradient = true;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              if (_isBoxVisible) ...[
                                // Animated Lottie Box
                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outerbox/Outerbox.json", // Replace with actual file path
                                  width: MediaQuery.of(context).size.width *
                                      0.87, // Match previous maxWidth
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.fill,
                                  // controller: _boxAnimationController,
                                  repeat: false,
                                  // controller: _boxAnimationController, // Attach animation controller if needed
                                ),

                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outer Glow/Outerbox.json", // Replace with actual file path
                                  width: MediaQuery.of(context).size.width *
                                      0.87, // Match previous maxWidth
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.fill,
                                  // controller: _glowAnimationController,
                                  //  repeat: true,
                                  // controller: _boxAnimationController, // Attach animation controller if needed
                                  repeat: repeatGlow,
                                  // onLoaded: (composition) {
                                  //   // Timer starts ONLY when the animation first loads
                                  //   Future.delayed(textAnimationDuration, () {
                                  //     setState(() {
                                  //       repeatGlow =
                                  //           false; // Stop repeating after 5 seconds
                                  //     });
                                  //   });
                                  // },
                                ),

                                // Overlay text and icons inside the animated box
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 18, right: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          // Wrap the Column in a Container with margin
                                          margin: EdgeInsets.only(
                                              left: 5, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextAnimator(
                                                "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.",
                                                incomingEffect:
                                                    WidgetTransitionEffects(
                                                        blur: const Offset(
                                                            10, 10),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    800)),
                                                outgoingEffect:
                                                    WidgetTransitionEffects(
                                                        blur: const Offset(
                                                            10, 10)),
                                                atRestEffect:
                                                    WidgetRestingEffects.wave(
                                                        effectStrength: 0.2,
                                                        duration: Duration(
                                                            milliseconds: 750),
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
                                                initialDelay: const Duration(
                                                    milliseconds: 0),
                                                spaceDelay: const Duration(
                                                    milliseconds: 100),
                                                characterDelay: const Duration(
                                                    milliseconds: 10),
                                                maxLines: 8,
                                              ),

                                              // Icons Row with Fade-In Animation
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 100),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ]
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

          // Scroll to top after adding the reply
          _scrollToBottom();

          replyController.forward();
        }
      });
    }
  }

  void _sendCard(String response) {
    if (true) {
      final String messageText =
          !_controller.text.isEmpty ? _controller.text : voicetext;
      _controller.clear();

      // Create an animation controller for the user's message animation
      AnimationController animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );

      animationController.addListener(() {
        if (animationController.value >= 0.65 && !isThresholdReached) {
          setState(() {
            isThresholdReached = true;
          });
          print("State changed at 85% progress");
        }
      });

      AnimationController _sparkleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
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
        Future.delayed(Duration(milliseconds: 0), () {
          _isSendingMessage = true;
          // _isGlowVisible = true;
        });

        messages.insert(
            0,
            AnimatedMessageBubble(
              message: messageText,
              alignment: Alignment.centerRight,
              animation: slideAnimation,
              controller: animationController,
              bubbleColor: Colors.white,
              textColor: Colors.black,
            ));
      });

      animationController.forward();
      _sparkleController.forward();

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
          bool repeatGlow = true;
          bool _isGlowVisible = true;
          bool _isBoxVisible = false;
          int textDurationMs = (response.length * 10) +
              800; // Character delay (10ms) + full effect (800ms)
          Duration textAnimationDuration =
              Duration(milliseconds: textDurationMs + 1000);
          late AnimationController _gradientcontroller;
          late Animation<double> _opacityAnimation;

          _gradientcontroller = AnimationController(
            vsync: this,
            duration: Duration(seconds: 2), // Adjust based on Lottie duration
          );

          // Opacity Tween
          _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: _gradientcontroller, curve: Curves.easeInOut),
          );

          // Start the animation
          _gradientcontroller.forward();

          late AnimationController _imagecontroller;
          double _opacity = 0.0; // Initial opacity
          bool _applyBlur = false;

          _imagecontroller = AnimationController(vsync: this);

          // Listen to the animation progress and update opacity
          _imagecontroller.addListener(() {
            setState(() {
              _opacity =
                  _imagecontroller.value; // Opacity follows animation progress
            });
          });
          _imagecontroller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _applyBlur = true;
              });
            }
          });

          setState(() {
            messages.insert(
              0,
              StatefulBuilder(
                builder: (context, setLocalState) {
                  bool hasShownGradient = false; // Add this flag

                  Future.delayed(Duration(milliseconds: 2000), () {
                    setLocalState(() {
                      _isBoxVisible = true;
                      _isGlowVisible =
                          !hasShownGradient; // Only show if not shown before
                    });

                    // Add this to hide the glow after one animation
                    Future.delayed(Duration(milliseconds: 800), () {
                      setLocalState(() {
                        _isGlowVisible = false;
                        hasShownGradient = true; // Mark as shown
                      });
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
                          child: Stack(
                            children: [
                              // Only show gradient animation if not shown before
                              if (!hasShownGradient)
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 800),
                                  opacity: !_isGlowVisible ? 0.0 : 1.0,
                                  child: Lottie.asset(
                                    'assets/animations/All Lottie/Glowing Star/Image Preload Gradient.json',
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    fit: BoxFit.cover,
                                    repeat: false,
                                    onLoaded: (composition) {
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        setLocalState(() {
                                          _isGlowVisible = false;
                                          hasShownGradient = true;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              if (_isBoxVisible) ...[
                                // Animated Lottie Box
                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outerbox/Outerbox.json", // Replace with actual file path
                                  width: MediaQuery.of(context).size.width *
                                      0.87, // Match previous maxWidth
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  fit: BoxFit.fill,
                                  // controller: _boxAnimationController,
                                  repeat: false,
                                  // controller: _boxAnimationController, // Attach animation controller if needed
                                ),

                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outer Glow/Outerbox.json", // Replace with actual file path
                                  width: MediaQuery.of(context).size.width *
                                      0.87, // Match previous maxWidth
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  fit: BoxFit.fill,
                                  // controller: _glowAnimationController,
                                  //  repeat: true,
                                  // controller: _boxAnimationController, // Attach animation controller if needed
                                  repeat: repeatGlow,
                                  // onLoaded: (composition) {
                                  //   // Timer starts ONLY when the animation first loads
                                  //   Future.delayed(textAnimationDuration, () {
                                  //     setState(() {
                                  //       repeatGlow =
                                  //           false; // Stop repeating after 5 seconds
                                  //     });
                                  //   });
                                  // },
                                ),

                                // Overlay text and icons inside the animated box
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 18, right: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          // Wrap the Column in a Container with margin
                                          margin: EdgeInsets.only(
                                              top: 10, left: 5, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextAnimator(
                                                "Here is a reference to the card",
                                                incomingEffect:
                                                    WidgetTransitionEffects(
                                                        blur: const Offset(
                                                            10, 10),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    800)),
                                                outgoingEffect:
                                                    WidgetTransitionEffects(
                                                        blur: const Offset(
                                                            10, 10)),
                                                atRestEffect:
                                                    WidgetRestingEffects.wave(
                                                        effectStrength: 0.2,
                                                        duration: Duration(
                                                            milliseconds: 750),
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
                                                initialDelay: const Duration(
                                                    milliseconds: 0),
                                                spaceDelay: const Duration(
                                                    milliseconds: 100),
                                                characterDelay: const Duration(
                                                    milliseconds: 10),
                                                maxLines: 8,
                                              ),

                                              //card image
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Card image with fade-in effect
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 100),
                                                        curve: Curves.easeInOut,
                                                        opacity: ((_opacity -
                                                                    0.5) <=
                                                                0.0)
                                                            ? 0
                                                            : _opacity - 0.5,
                                                        child: Image.asset(
                                                          'assets/images/login.jpg',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),

                                                    // Lottie animation over the image
                                                    Positioned.fill(
                                                      child: Lottie.asset(
                                                        'assets/animations/gradient.json',
                                                        fit: BoxFit.cover,
                                                        repeat: false,
                                                        controller:
                                                            _imagecontroller,
                                                        onLoaded:
                                                            (composition) {
                                                          _imagecontroller
                                                            ..duration =
                                                                composition
                                                                    .duration
                                                            ..forward();
                                                        },
                                                      ),
                                                    ),

                                                    // Updated text overlay with fade-in animation
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 50,
                                                      child: AnimatedOpacity(
                                                        duration: Duration(
                                                            milliseconds: 800),
                                                        curve: Curves.easeIn,
                                                        opacity: _opacity >= 0.8
                                                            ? 1.0
                                                            : 0.0, // Only show text when image is mostly faded in
                                                        child: AnimatedBuilder(
                                                          animation:
                                                              _imagecontroller,
                                                          builder:
                                                              (context, child) {
                                                            return Transform
                                                                .translate(
                                                              offset: Offset(
                                                                  0,
                                                                  _imagecontroller
                                                                              .value <
                                                                          0.8
                                                                      ? 20
                                                                      : 0), // Slide up animation
                                                              child: Text(
                                                                "Dolphins Doing a Backflip in the Ocean",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              // Icons Row with Fade-In Animation
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 100),
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
                                                    SizedBox(width: 45),
                                                    TextButton.icon(
                                                      onPressed: () {},
                                                      icon: Text(
                                                        "View More",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      label: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
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

          // Scroll to top after adding the reply
          _scrollToBottom();

          replyController.forward();
        }
      });
    }
  }

  void _toggleMessageBoxVisibility() {
    setState(() {
      _isMessageBoxVisible = !_isMessageBoxVisible;
      if (_isMessageBoxVisible) {
        // Only hide the animations if there's text in the input
        if (_controller.text.isNotEmpty) {
          _showMindText = false;
          _shouldShowTextBox = false;
          _mindcontroller.stop();
        }
      } else {
        _showMindText = true;
        _shouldShowTextBox = true;
        _mindcontroller.reset();
        _mindcontroller.forward();
      }
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // Full screen animation layer
          if (isThresholdReached)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Lottie.asset(
                  'assets/animations/All Lottie/BG Glow Gradient/3 in 1/BG Glow Gradient.json',
                  fit: BoxFit.cover,
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(
                      composition.duration + Duration(milliseconds: 390),
                      () {
                        setState(() {
                          _isSendingMessage = false;
                          isThresholdReached = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

          // Main content column
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.only(left: 8, top: 10),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isThresholdReached
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.more_horiz,
                              color: Colors.white, size: 22),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 8, top: 10),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isThresholdReached
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.stacked_bar_chart,
                                color: Colors.white, size: 22),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    if (messages.isEmpty)
                      Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: _shouldShowTextBox ? 1.0 : 0.0,
                            duration: Duration(
                                milliseconds:
                                    1500), // Increased from 800 to 1500ms
                            curve: Curves
                                .easeInOut, // Using easeInOut for smoother transition
                            child: Center(
                              child: Lottie.asset(
                                'assets/animations/BG small Blur/BG small Blur.json',
                                width: screenWidth / 0.9,
                                height: screenHeight / 1.8,
                                fit: BoxFit.fill,
                                controller: _mindcontroller,
                              ),
                            ),
                          ),
                          if (_shouldShowTextBox)
                            Center(
                              child: AnimatedOpacity(
                                opacity:
                                    _showContainer && _showMindText ? 1.0 : 0.0,
                                duration: Duration(
                                    milliseconds:
                                        1500), // Increased from 800 to 1500ms
                                curve: Curves
                                    .easeInOut, // Using easeInOut for smoother transition
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    width: screenWidth / 2.15,
                                    height: screenHeight / 13,
                                    color: Colors.white.withOpacity(0.1),
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "What's on your mind?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: screenWidth * 0.038,
                                        fontWeight: FontWeight.w600,
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
                            controller: _scrollController,
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return messages[index];
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
                                    child:
                                        _isMessageBoxVisible || _isLongPressing
                                            ? Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.blur_circular,
                                                color: Colors.white,
                                                size: 45,
                                              )),
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
                                      color: Colors
                                          .white10, // Semi-transparent background
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(
                                              0, 3), // Shadow offset
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      focusNode:
                                          _focusNode, // Assign the FocusNode
                                      maxLines: null, // Allow multiple lines
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(
                                          color: Colors
                                              .white), // Set text color to white
                                      decoration: InputDecoration(
                                        hintText: "Message",
                                        hintStyle: const TextStyle(
                                            color: Colors
                                                .white70), // Hint text color
                                        border:
                                            InputBorder.none, // Remove border
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                  width:
                                      8), // Spacing between input box and send button
                              // Send button
                              if (_isMessageBoxVisible)
                                IconButton(
                                  onPressed: () => _sendCard(sentence),
                                  icon: const Icon(Icons.send),
                                  color:
                                      Colors.white54, // Set icon color to white
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
                                            color:
                                                Color(0xFFA715E9), // Icon color
                                            size: 6, // Icon size
                                          ),
                                          SizedBox(
                                              width:
                                                  2), // Space between icon and text

                                          TextAnimator(
                                            displayText,
                                            incomingEffect:
                                                WidgetTransitionEffects(
                                                    blur: const Offset(10, 10),
                                                    duration: const Duration(
                                                        milliseconds: 500)),
                                            outgoingEffect:
                                                WidgetTransitionEffects(
                                                    blur: const Offset(10, 10)),
                                            atRestEffect:
                                                WidgetRestingEffects.wave(
                                                    effectStrength: 0.2,
                                                    duration: Duration(
                                                        milliseconds: 750),
                                                    numberOfPlays: 1),
                                            style: TextStyle(
                                                fontFamily: "Original",
                                                color: Colors.white,
                                                fontSize: 15),
                                            textAlign: TextAlign.left,
                                            initialDelay:
                                                const Duration(milliseconds: 0),
                                            spaceDelay: const Duration(
                                                milliseconds: 100),
                                            characterDelay: const Duration(
                                                milliseconds: 10),
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
                              Container(
                                height: screenHeight *
                                    0.4, // Increased height for better visibility
                                alignment: Alignment.bottomCenter,
                                child: Lottie.asset(
                                  "assets/animations/All Lottie/Down Ripple/Ripple.json",
                                  width: MediaQuery.of(context).size.width,
                                  height: screenHeight * 0.25,
                                  fit: BoxFit.fill,
                                  repeat: true,
                                  animate: true,
                                  controller: _rippleController,
                                ),
                              ),
                              Positioned(
                                bottom:
                                    screenHeight * 0.08, // Adjusted position
                                left: 16,
                                right: 16,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
                                        milliseconds:
                                            100), // Reduced initial delay
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
    super.key,
    required this.message,
    required this.alignment,
    required this.animation,
    required this.controller,
    required this.bubbleColor,
    required this.textColor,
  });

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
