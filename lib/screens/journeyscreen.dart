import 'package:flutter/material.dart';

class Journeyscreen extends StatefulWidget {
  const Journeyscreen({super.key});

  @override
  State<Journeyscreen> createState() => _JourneyscreenState();
}

class _JourneyscreenState extends State<Journeyscreen> {
  final List<Map<String, dynamic>> journeyItems = [
    {
      'title': 'Small Change, Big Impact',
      'progress': '3/5 achieved',
      'icon': Icons.water_drop,
      'isCompleted': true,
    },
    {
      'title': 'Meet Your Future Self',
      'progress': '2/5 achieved',
      'icon': Icons.sailing,
      'isCompleted': true,
    },
    {
      'title': 'The Secrets of Self-Compassion',
      'progress': '1/5 achieved',
      'icon': Icons.hiking,
      'isCompleted': false,
    },
    {
      'title': 'Your Feelings Matter',
      'progress': 'Not yet unlocked',
      'icon': Icons.diamond,
      'isCompleted': false,
    },
    {
      'title': 'Celebrate Your Steps to Success',
      'progress': 'Not yet unlocked',
      'icon': Icons.assignment,
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: AssetImage("assets/images/sample2.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '6/25 events achieved',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  '24% completion',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 46),
          Expanded(
              child: ListView.builder(
            itemCount: journeyItems.length,
            itemBuilder: (context, index) {
              final item = journeyItems[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: item['isCompleted']
                              ? const Color.fromARGB(255, 102, 179, 55)
                              : const Color.fromARGB(255, 203, 195, 195),
                          child: Icon(
                            item['icon'],
                            size: 20,
                            color: item['isCompleted']
                                ? const Color.fromARGB(255, 252, 252, 252)
                                : const Color.fromARGB(255, 102, 101, 101),
                          ),
                        ),
                        if (index != journeyItems.length - 1)
                          DottedLineNearIcon(),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['progress'],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

class DottedLineNearIcon extends StatelessWidget {
  const DottedLineNearIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 50,
      child: CustomPaint(
        painter: DottedLinePainter(),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    double startY = 0;
    final dashHeight = 4;
    final spaceHeight = 4;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + spaceHeight;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
