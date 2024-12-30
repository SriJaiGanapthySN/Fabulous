import 'package:fab/compenents/guidedcoachingtile.dart';
import 'package:flutter/material.dart';

class Guidedcoachingsecondlevel extends StatefulWidget {
  const Guidedcoachingsecondlevel({super.key});

  @override
  State<Guidedcoachingsecondlevel> createState() =>
      _GuidedcoachingsecondlevelState();
}

class _GuidedcoachingsecondlevelState extends State<Guidedcoachingsecondlevel> {
  final List<Map<String, String>> tilesData = [
    {'url': 'assets/images/sample.jpg', 'title': 'Exercise 1', 'time': '3 min'},
    {
      'url': 'assets/images/sample2.jpg',
      'title': 'Exercise 2',
      'time': '9 min'
    },
    {
      'url': 'assets/images/sample3.jpg',
      'title': 'Exercise 3',
      'time': '13 min'
    },
    {
      'url': 'assets/images/sample.jpg',
      'title': 'Exercise 4',
      'time': '23 min'
    },
    {'url': 'assets/images/login.jpg', 'title': 'Exercise 5', 'time': '33 min'},
    {
      'url': 'assets/images/sample2.jpg',
      'title': 'Exercise 6',
      'time': '31 min'
    },
    {
      'url': 'assets/images/sample3.jpg',
      'title': 'Exercise 7',
      'time': '33 min'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sample.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // CustomScrollView with a pinned SliverAppBar
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // Pinned SliverAppBar
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    "Exercise",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Content List
              SliverPadding(
                padding: const EdgeInsets.only(top: 200),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final tile = tilesData[index];
                      return Column(
                        children: [
                          Guidedcoachingtile(
                            url: tile['url']!,
                            title: tile['title']!,
                            timestamp: tile['time']!,
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                    childCount: tilesData.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
