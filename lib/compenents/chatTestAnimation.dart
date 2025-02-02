import 'package:flutter/material.dart';

class EvaporateText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration wordDuration; // Duration for each word animation

  EvaporateText({
    required this.text,
    required this.textStyle,
    this.wordDuration = const Duration(milliseconds: 400), // Default 400ms per word
  });

  @override
  _EvaporateTextState createState() => _EvaporateTextState();
}

class _EvaporateTextState extends State<EvaporateText> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<String> words;

  @override
  void initState() {
    super.initState();
    words = widget.text.split(" "); // Split into words

    _controllers = List.generate(words.length, (index) {
      return AnimationController(
        duration: widget.wordDuration,
        vsync: this,
      );
    });

    _animations = List.generate(words.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controllers[index], curve: Curves.easeOut),
      );
    });

    // Start animations one by one with delay
    for (int i = 0; i < words.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
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
    double maxTextWidth = screenWidth * 0.8; // Limit text width to 80% of screen

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: maxTextWidth,
        child: CustomPaint(
          size: Size(maxTextWidth, 300), // Increased height for multiline support
          painter: EvaporateTextPainter(
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

class EvaporateTextPainter extends CustomPainter {
  final List<String> words;
  final TextStyle textStyle;
  final List<Animation<double>> animations;
  final double maxWidth;

  EvaporateTextPainter({
    required this.words,
    required this.textStyle,
    required this.animations,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double xOffset = 0, yOffset = size.height * 0.2; // Start from lower third

    for (int i = 0; i < words.length; i++) {
      final progress = animations[i].value;
      double colorFactor = progress < 0.7 ? 0 : (progress - 0.7) / 0.3;
      final color = Color.lerp(Colors.blue[900], Colors.white, colorFactor)!;

      final wordPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: textStyle.copyWith(
            color: color.withOpacity(progress),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      wordPainter.layout();

      // Move words up as they appear
      double wordYOffset = yOffset - (wordPainter.height * progress);

      // **Fix**: If next word exceeds maxWidth, move to next line
      if (xOffset + wordPainter.width > maxWidth) {
        xOffset = 0;
        yOffset += wordPainter.height + 10; // Line spacing
        wordYOffset = yOffset - (wordPainter.height * progress);
      }

      wordPainter.paint(canvas, Offset(xOffset, wordYOffset));
      xOffset += wordPainter.width + 8; // Space between words
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}