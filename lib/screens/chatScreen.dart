import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class ChatScreen extends StatefulWidget {
  final String email;

  const ChatScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Widget> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Combine animations for a single message
        messages.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft, // Adjust alignment as needed
              child: CombinedAnimatedText(
                text: _controller.text,
              ),
            ),
          ),
        );
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true, // Latest message at the bottom
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
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
          // overlapFactor: 0.05,
          textStyle: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    );
  }
}