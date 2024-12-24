import 'package:flutter/material.dart';

class Notesscreen extends StatelessWidget {
  final String title;
  final List<String> items;
  final String timestamp;

  const Notesscreen({
    super.key,
    required this.title,
    required this.items,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Colors.red,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                maxLines: 25, // Makes the input box bigger
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                  hintText: "What's on your mind?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
