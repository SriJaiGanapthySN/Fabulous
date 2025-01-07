import 'package:flutter/material.dart';

class JourneySecondLevel extends StatefulWidget {
  const JourneySecondLevel({super.key});

  @override
  State<JourneySecondLevel> createState() => _JourneySecondLevelState();
}

class _JourneySecondLevelState extends State<JourneySecondLevel>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> cardData = [
    {
      'title': 'Your Letter no. 1',
      'subtitle': 'Mind the Gap',
      'status': '1/5',
      'completed': true,
      'progress': false,
    },
    {
      'title': 'Goal',
      'subtitle': 'Drink water',
      'status': '2/5',
      'completed': true,
      'progress': false,
    },
    {
      'title': 'One-Time Action',
      'subtitle': 'Prepare a Glass of Water',
      'status': '3/5',
      'completed': true,
      'progress': false,
    },
    {
      'title': 'Daily Action',
      'subtitle': 'Set a Reminder to Drink',
      'status': '4/5',
      'completed': false,
      'progress': true,
    },
    {
      'title': 'MOTIVATOR',
      'subtitle': 'Review Your Progress',
      'status': '5/5',
      'completed': false,
      'progress': false,
    },
  ];

  late ScrollController _scrollController;
  double _iconScale = 1.0;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();
  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.6, end: 1.2).animate(_controller);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.2).animate(_controller);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          double offset = _scrollController.offset;
          _iconScale = (1 - offset / 200).clamp(0.5, 1.0);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text(
              "Small Change, Big Impact",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 210,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/meditation.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Transform.scale(
                    scale: _iconScale,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.water_drop,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Card List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final card = cardData[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(26),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        card['title'],
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        card['subtitle'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 35),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 8),
                                          Text(
                                            card['completed'] == true
                                                ? 'COMPLETED'
                                                : card['progress'] == true
                                                    ? 'IN PROGRESS'
                                                    : 'LOCKED',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: card['completed'] == true
                                                  ? Colors.green
                                                  : card['progress'] == true
                                                      ? Colors.blue
                                                      : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: card['completed'] == true
                                    ? Colors.green
                                    : card['progress'] == true
                                        ? Colors.blue
                                        : Colors.grey,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    topRight: Radius.circular(5)),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  card['status'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: cardData.length,
            ),
          ),
        ],
      ),
    );
  }
}
