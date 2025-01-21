import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class ChatScreen extends StatefulWidget {
  final String email;

  const ChatScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<Widget> messages = [];
  final TextEditingController _controller = TextEditingController();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/videos/chatBg.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is initialized
        _videoController.setLooping(true); // Loop the video
        _videoController.play(); // Play the video
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose of the video controller
    _controller.dispose(); // Dispose of the text controller
    super.dispose();
  }


//I am feeling burnedout. Any suggestion for recharging
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
      begin: const Offset(0, 10), // Start from the bottom
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
        // Create an animation controller for the reply bubble's color intensity
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

        setState(() {
          messages.add(
            AnimatedBuilder(
              animation: colorAnimation,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                      decoration: BoxDecoration(
                        color: colorAnimation.value, // Dynamically update the bubble's color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CombinedAnimatedText(
                        text: "How about a rejuvenating walk outside? It's a great way to refresh your mind and uplift your spirits.",
                      ),
                    ),
                  ),
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10, // Semi-transparent background
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
                          style: const TextStyle(color: Colors.white), // Set text color to white
                          decoration: InputDecoration(
                            hintText: "Message",
                            hintStyle: const TextStyle(color: Colors.white70), // Hint text color
                            border: InputBorder.none, // Remove border
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      color: Colors.white54, // Set icon color to white
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

class CombinedAnimatedText extends StatelessWidget {
  final String text;

  const CombinedAnimatedText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlurText(
          text: text,
          duration: const Duration(milliseconds: 800),
          type: AnimationType.word,
          textStyle: const TextStyle(fontSize: 15, color: Colors.blueAccent),
        ),
        OffsetText(
          text: text,
          duration: const Duration(milliseconds: 800),
          type: AnimationType.word,
          slideType: SlideAnimationType.bottomTop,
          textStyle: const TextStyle(fontSize: 15, color: Colors.white),
        ),
      ],
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
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
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