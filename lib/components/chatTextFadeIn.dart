import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FadeInText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration wordDuration;

  FadeInText({
    required this.text,
    required this.textStyle,
    this.wordDuration = const Duration(milliseconds: 400),
  });

  @override
  _FadeInTextState createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<String> words;

  @override
  void initState() {
    super.initState();
    words = widget.text.split(" ");

    _controllers = List.generate(words.length, (index) {
      return AnimationController(
        duration: widget.wordDuration,
        vsync: this,
      );
    });

    _animations = List.generate(words.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeOutCubic,
        ),
      );
    });

    // Start animations with 80ms delay (20% of 400ms duration)
    for (int i = 0; i < words.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxTextWidth = screenWidth * 0.8;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: maxTextWidth,
        child: CustomPaint(
          size: Size(maxTextWidth, 300),
          painter: FadeInTextPainter(
            words: words,
            textStyle: widget.textStyle,
            animations: _animations,
            maxWidth: maxTextWidth,
          ),
        ),
      ),
    );
  }
}

class FadeInTextPainter extends CustomPainter {
  final List<String> words;
  final TextStyle textStyle;
  final List<Animation<double>> animations;
  final double maxWidth;

  FadeInTextPainter({
    required this.words,
    required this.textStyle,
    required this.animations,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double xOffset = 0;
    double yOffset = 0;
    double lineHeight = 0;

    for (int i = 0; i < words.length; i++) {
      final progress = animations[i].value;
      Color wordColor;

      // If the next word's animation is complete, change the current word to white
      if (i < words.length - 1 && animations[i + 1].value == 1.0) {
        wordColor = Colors
            .white; // Previous word turns white when next word is complete
      } else {
        // Color transition during the current word's animation
        wordColor = Color.lerp(
          Colors.blue[900],
          Colors.blue[300],
          progress /
              1, // Transitioning from dark blue to light blue in 95% of animation
        )!;
      }

      // Calculate blur and movement
      double verticalMove = 25 * (1 - progress);
      double blurSigma = 4 * (1 - progress);

      final wordPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: textStyle.copyWith(
            color: wordColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      wordPainter.layout();

      lineHeight =
          lineHeight < wordPainter.height ? wordPainter.height : lineHeight;

      if (xOffset + wordPainter.width > maxWidth) {
        xOffset = 0;
        yOffset += lineHeight + 10;
        lineHeight = wordPainter.height;
      }

      canvas.saveLayer(
        Rect.fromLTWH(xOffset - 15, yOffset - 15, wordPainter.width + 30,
            wordPainter.height + 30),
        Paint()
          ..imageFilter = ui.ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
      );

      wordPainter.paint(
        canvas,
        Offset(xOffset, yOffset + verticalMove),
      );

      canvas.restore();
      xOffset += wordPainter.width + 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
