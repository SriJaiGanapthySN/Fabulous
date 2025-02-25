import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final String email;

  const ChatScreen({super.key, required this.email});

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
  late AnimationController _sparkleController;
  late Animation<Color?> _colorAnimation;
  bool isListening = false;
  final ScrollController _scrollController = ScrollController();
  bool isThresholdReached = false;
  bool _isMessageBoxVisible = false;
  final FocusNode _focusNode = FocusNode();
  double _opacity = 0.0;
  bool _isLongPressing = false;
  String displayText = "Hold to Speak";
  late Timer _timer;
  bool _isReversing = false;
  bool _isRippleDone = false;
  bool _showContainer = false;
  double _scale = 0.0;
  bool _isSendingMessage = false;
  String voicetext = "";
  bool _shouldShowTextBox = false;
  bool _showMindText = true;
  late AnimationController _boxAnimationController;
  late AnimationController _glowAnimationController;
  late AnimationController _animationController;
  final String sentence =
      "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits. ";
  late stt.SpeechToText speech;

  bool isquestion = false;
  Color _backgroundColor = Colors.transparent;

  void requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      print("Microphone permission denied");
    }
  }

  @override
  void initState() {
    super.initState();

    speech = stt.SpeechToText();
    requestPermissions();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showContainer = true;
        _scale = 1.0;
      });
    });

    _mindcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() {
        setState(() {
          _shouldShowTextBox = true;
        });
        if (_mindcontroller.value > 0.99 && !_isReversing) {
          _isReversing = true;
          _mindcontroller.reverse();
        } else if (_mindcontroller.value < 0.13 && _isReversing) {
          _isReversing = false;
          _mindcontroller.forward();
        }
      });

    _mindcontroller.forward();

    _mindboxcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

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

    int textDurationMs = (sentence.length * 10) + 800;
    Duration textAnimationDuration = Duration(milliseconds: textDurationMs);

    _boxAnimationController = AnimationController(
      vsync: this,
      duration: textAnimationDuration,
    );

    _glowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _boxAnimationController.forward();
    _glowAnimationController.forward();

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

  @override
  void dispose() {
    _videoController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _rippleController.dispose();
    _animationController.dispose();
    _mindcontroller.dispose();
    _mindboxcontroller.dispose();
    _boxAnimationController.dispose();
    _glowAnimationController.dispose();
    _ccontroller.dispose();
    _sparkleController.dispose();
    _timer.cancel();

    super.dispose();
  }

  void _startlisten() async {
    bool available = await speech.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );

    if (available) {
      setState(() {
        isListening = true;
      });
      speech.listen(
        onResult: (result) {
          setState(() {
            voicetext = result.recognizedWords;
          });
        },
      );
    }
  }

  void _startTextSwitching() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        displayText =
            (displayText == "Hold to Speak") ? "Tap to Chat" : "Hold to Speak";
      });
    });
  }

  void _stopListening() {
    setState(() => isListening = false);
    speech.stop();
    setState(() {
      voicetext = "";
    });
  }

  void checkquestion(String text) {
    text = text.trim();
    if (text.endsWith("?")) {
      setState(() {
        isquestion = true;
      });
      print("true");
    } else {
      List<String> questionWords = [
        "what",
        "where",
        "why",
        "how",
        "explain",
        "some tips",
        "give",
        "any",
        "advise me",
        "brief me",
        "share",
        "list",
        "can you",
        "can we",
        "could you",
        "could we",
        "do you",
        "i need",
        "suggest",
        "is it",
        "are we",
        "are you",
        "do you",
        "does anyone",
        "should i",
        "should we",
        "gonna",
        "wanna",
        "shall we",
        "shouldn't we",
        "wouldn't it",
        "haven't you",
        "hasn't she",
        "hasn't he",
        "hasn't it",
        "didn't she",
        "didn't he",
        "aren't",
        "would you",
        "will that work"
      ];

      List<String> words = text.toLowerCase().split(RegExp(r'\s+'));

      if (questionWords.contains(words.first)) {
        print("true");
        setState(() {
          isquestion = true;
        });
      } else {
        print("false");
        setState(() {
          isquestion = false;
        });
      }
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressing = true;
      _showMindText = false;
      _shouldShowTextBox = false;
      _mindcontroller.stop();
      _rippleController.reset();
      _rippleController.forward();
      _startlisten();
     
    });
    
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _sendCard(voicetext);
      _isLongPressing = false;
      _showMindText = true;
      _shouldShowTextBox = true;
      _mindcontroller.reset();
      _mindcontroller.forward();
      _stopListening();
    });
  }

  void _sendMessage(String response) {
    if (!mounted) return;

    final String messageText =
        _controller.text.isNotEmpty ? _controller.text.trim() : voicetext;
    _controller.clear();

    checkquestion(messageText);

    AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, -3.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutQuint,
    ));

    if (mounted) {
      setState(() {
        Future.delayed(Duration(milliseconds: 0), () {
          _isSendingMessage = true;
        });
        if (messageText.isNotEmpty) {
          messages.add(AnimatedMessageBubble(
            message: messageText,
            alignment: Alignment.centerRight,
            animation: slideAnimation,
            controller: animationController,
            bubbleColor: Colors.white,
            textColor: Colors.black,
          ));
        }
      });
    }

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
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

        double iconOpacity = 0.0;
        bool repeatGlow = true;
        bool _isGlowVisible = true;
        bool _isBoxVisible = false;
        int textDurationMs = (response.length * 10) + 800;

        late AnimationController _gradientcontroller;

        _gradientcontroller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800),
        );

        _gradientcontroller.forward();

        late AnimationController _imagecontroller;
        double _opacity = 0.0;
        bool _applyBlur = false;
        bool outerGlow = true;

        _imagecontroller = AnimationController(vsync: this);

        _imagecontroller.addListener(() {
          setState(() {
            _opacity = _imagecontroller.value;
          });
        });
        _imagecontroller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _applyBlur = true;
            });
          }
        });

        Future.delayed(Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });

        setState(() {
          messages.add(
            StatefulBuilder(
              builder: (context, setLocalState) {
                if (context.mounted) {
                  Future.delayed(Duration(milliseconds: isquestion ? 2000 : 0),
                      () {
                    if (context.mounted) {
                      setLocalState(() {
                        _isBoxVisible = true;
                      });
                    }

                    Future.delayed(Duration(milliseconds: 800), () {
                      if (context.mounted) {
                        if (context.mounted) {
                          setLocalState(() {
                            _isGlowVisible = false;

                            Future.delayed(Duration(milliseconds: 500), () {
                              if (context.mounted) {
                                setLocalState(() {
                                  iconOpacity = 1.0;
                                  repeatGlow = false;
                                });
                              }
                            });
                          });
                        }
                      }
                    });
                  });
                }

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
                            if (_isGlowVisible)
                              Lottie.asset(
                                'assets/animations/All Lottie/Glowing Star/Image Preload Gradient.json',
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                fit: BoxFit.cover,
                                repeat: false,
                              ),
                            if (_isBoxVisible) ...[
                              Lottie.asset(
                                "assets/animations/Inner+Outerbox+Glow/Outerbox/Outerbox.json",
                                width: MediaQuery.of(context).size.width * 0.87,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                fit: BoxFit.fill,
                                repeat: false,
                              ),
                              if (outerGlow)
                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outer Glow/Outerbox.json",
                                  width:
                                      MediaQuery.of(context).size.width * 0.87,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  fit: BoxFit.fill,
                                  repeat: repeatGlow,
                                ),
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
                                                      blur:
                                                          const Offset(10, 10),
                                                      duration: const Duration(
                                                          milliseconds: 800)),
                                              outgoingEffect:
                                                  WidgetTransitionEffects(
                                                      blur:
                                                          const Offset(10, 10)),
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
                                                color: Colors.white,
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
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 100),
                                                      curve: Curves.easeInOut,
                                                      opacity:
                                                          ((_opacity - 0.5) <=
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
                                                  Positioned.fill(
                                                    child: Lottie.asset(
                                                      'assets/animations/gradient.json',
                                                      fit: BoxFit.cover,
                                                      repeat: false,
                                                      controller:
                                                          _imagecontroller,
                                                      onLoaded: (composition) {
                                                        _imagecontroller
                                                          ..duration =
                                                              composition
                                                                  .duration
                                                          ..forward();
                                                      },
                                                    ),
                                                  ),
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
                                                          : 0.0,
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
                                                                    : 0),
                                                            child: Text(
                                                              "Dolphins Doing a Backflip in the Ocean",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
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
                                            Container(
                                              margin: EdgeInsets.only(top: 1),
                                              child: AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                opacity: iconOpacity,
                                                curve: Curves.easeIn,
                                                child: SizedBox(
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .heart,
                                                          color: Colors.white,
                                                          size: 10,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: FaIcon(
                                                          FontAwesomeIcons.plus,
                                                          color: Colors.white,
                                                          size: 10,
                                                        ),
                                                      ),
                                                      SizedBox(width: 45),
                                                      TextButton.icon(
                                                        onPressed: () {},
                                                        icon: Text(
                                                          "View More",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
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
      }
    });
  }

  void _sendCard(String response) {
    if (true) {
      final String messageText =
          _controller.text.isNotEmpty ? _controller.text.trim() : voicetext;
      _controller.clear();

      checkquestion(messageText);

      // If it's a question, scroll up slightly
      // if (isquestion && _scrollController.hasClients) {
      //   double currentOffset = _scrollController.offset;
      //   _scrollController.animateTo(
      //     currentOffset + 50.0, // Scroll up by 50 pixels
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.easeOut,
      //   );
      // }

      if (isquestion && _scrollController.hasClients) {
  double currentOffset = _scrollController.offset;
  double halfScreenHeight = MediaQuery.of(context).size.height / 2;

  _scrollController.animateTo(
    currentOffset + halfScreenHeight, // Scroll by half of screen height
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}

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
        begin: const Offset(-10, 80),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutQuint,
      ));

      setState(() {
        Future.delayed(Duration(milliseconds: 0), () {
          _isSendingMessage = true;
        });

        messages.add(AnimatedMessageBubble(
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

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Reset isquestion after animation completes
          Future.delayed(Duration(milliseconds: 6300), () {
            setState(() {
              isquestion = false;
            });
          });

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

          double iconOpacity = 0.0;
          bool repeatGlow = true;
          bool _isGlowVisible = true;
          bool _isBoxVisible = false;

          late AnimationController _gradientcontroller;

          _gradientcontroller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 800),
          );

          _gradientcontroller.forward();

          late AnimationController _imagecontroller;
          double _opacity = 0.0;
          bool _applyBlur = false;
          double opacityLevel = 1.0;
          double quesOpacityLevel = 1.0;
          bool _isQuesAnimVisible = true;

          _imagecontroller = AnimationController(vsync: this);

          _imagecontroller.addListener(() {
            setState(() {
              _opacity = _imagecontroller.value;
            });
          });
          _imagecontroller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _applyBlur = true;
              });
            }
          });
          void decreaseOpacity() async {
            for (double i = 1.0; i >= 0.0; i -= 0.05) {
              await Future.delayed(
                  Duration(milliseconds: 100)); // Smooth transition
              setState(() {
                opacityLevel = i;
              });
            }
          }

          setState(() {
            messages.add(
              StatefulBuilder(
                builder: (context, setLocalState) {
                  Future.delayed(Duration(milliseconds: 2100), () {
                    if (mounted) {
                      setLocalState(() {
                        // gow = false;
                        decreaseOpacity();

                        Future.delayed(Duration(milliseconds: 500), () {
                          setLocalState(() {
                            _isGlowVisible = false;
                          });
                        });
                      });
                    }
                  });
                  Future.delayed(
                      Duration(milliseconds: isquestion ? 4200 : 2000), () {
                    setLocalState(() {
                      _isBoxVisible = true;
                      Future.delayed(Duration(milliseconds: 800), () {
                        setLocalState(() {
                          iconOpacity = 1.0;
                          repeatGlow = false;
                          _isQuesAnimVisible = false;
                        });
                        isquestion? setState(() {
                          // isquestion = false;
                          isThresholdReached = false;
                        }):null;
                      });
                    });
                  });

                  Future.delayed(Duration(milliseconds: 300), () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
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
                              if (_isGlowVisible && !isquestion)
                                AnimatedOpacity(
                                  opacity: opacityLevel,
                                  duration: Duration(milliseconds: 300),
                                  child: Lottie.asset(
                                    'assets/animations/All Lottie/Glowing Star/Image Preload Gradient.json',
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    fit: BoxFit.cover,
                                    repeat: true,
                                  ),
                                ),
                              if (_isQuesAnimVisible && isquestion)
                                AnimatedOpacity(
                                  opacity: quesOpacityLevel,
                                  duration: Duration(milliseconds: 300),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Lottie.asset(
                                      "assets/animations/QnA/6. Everything combined/data.json",
                                      // width:
                                      //     MediaQuery.of(context).size.width * 0.8,
                                      // height: MediaQuery.of(context).size.height *
                                      //     0.5,
                                      fit: BoxFit.fill,
                                      repeat: false,
                                    ),
                                  ),
                                ),
                              if (_isBoxVisible) ...[
                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outerbox/Outerbox.json",
                                  width:
                                      MediaQuery.of(context).size.width * 0.87,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  fit: BoxFit.fill,
                                  repeat: false,
                                ),
                                Lottie.asset(
                                  "assets/animations/Inner+Outerbox+Glow/Outer Glow/Outerbox.json",
                                  width:
                                      MediaQuery.of(context).size.width * 0.87,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  fit: BoxFit.fill,
                                  repeat: repeatGlow,
                                ),
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
                                                  color: Colors.white,
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
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
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
                                                            : 0.0,
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
                                                                      : 0),
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
                                              // SizedBox(height: 20),
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 500),
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
        }
      });
    }
  }

  void _toggleMessageBoxVisibility() {
    setState(() {
      _isMessageBoxVisible = !_isMessageBoxVisible;
      if (_isMessageBoxVisible) {
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

    if (_isMessageBoxVisible) {
      Future.delayed(const Duration(milliseconds: 10), () {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else {
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
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: isquestion ? Colors.black : Colors.transparent,
                image: !isquestion
                    ? DecorationImage(
                        image: AssetImage('assets/images/bg.jpeg'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          if (isThresholdReached)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: !isquestion
                    ? Lottie.asset(
                        // isquestion
                        //     ? 'assets/animations/data.json'
                        //     :
                        // 'assets/animations/data.json',
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
                      )
                    : null,
              ),
            ),
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
              Expanded(
                child: Stack(
                  children: [
                    if (messages.isEmpty)
                      Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: _shouldShowTextBox ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
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
                                duration: Duration(milliseconds: 1500),
                                curve: Curves.easeInOut,
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
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.only(
                                  bottom: (index == 0 && _isLongPressing)
                                      ? screenHeight * 0.15
                                      : 0,
                                ),
                                child: messages[index],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _toggleMessageBoxVisibility,
                                onLongPressStart: _onLongPressStart,
                                onLongPressEnd: _onLongPressEnd,
                                onLongPressDown: (_) {},
                                onLongPressUp: () {},
                                child: Container(
                                    width: 56,
                                    height: 56,
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
                              const SizedBox(width: 8),
                              if (_isMessageBoxVisible)
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Message",
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              if (_isMessageBoxVisible)
                                IconButton(
                                  onPressed: () => _sendCard(_controller.text),
                                  icon: const Icon(Icons.send),
                                  color: Colors.white54,
                                ),
                              if (!_isMessageBoxVisible)
                                Container(
                                  margin: EdgeInsets.only(left: 2),
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 2000),
                                    opacity: _opacity,
                                    child: Row(
                                      children: [
                                        if (!_isLongPressing) ...[
                                          Icon(
                                            Icons.circle_sharp,
                                            color: Color(0xFFA715E9),
                                            size: 6,
                                          ),
                                          SizedBox(width: 2),
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
                                height: screenHeight * 0.4,
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
                              if (voicetext.isNotEmpty)
                                Positioned(
                                  bottom: screenHeight * 0.08,
                                  left: 16,
                                  right: 16,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: TextAnimator(
                                      voicetext,
                                      incomingEffect: WidgetTransitionEffects
                                          .incomingSlideInFromBottom(),
                                      outgoingEffect: WidgetTransitionEffects
                                          .outgoingSlideOutToBottom(),
                                      atRestEffect: WidgetRestingEffects.wave(
                                          numberOfPlays: 1,
                                          effectStrength: 0.2),
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 2,
                                          fontSize: 20,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                      initialDelay:
                                          const Duration(milliseconds: 100),
                                      spaceDelay:
                                          const Duration(milliseconds: 50),
                                      characterDelay:
                                          const Duration(milliseconds: 20),
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
