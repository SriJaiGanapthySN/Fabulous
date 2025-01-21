// import 'package:fab/compenents/guidedcoachingtile.dart';
// import 'package:fab/screens/stackcard.dart';
// import 'package:fab/services/guided_activities.dart';
// import 'package:flutter/material.dart';

// class Guidedcoachingsecondlevel extends StatefulWidget {
//   final String email;
//   final Map<String, dynamic> category;
//   const Guidedcoachingsecondlevel({super.key,required this.email, required this.category});

//   @override
//   State<Guidedcoachingsecondlevel> createState() =>
//       _GuidedcoachingsecondlevelState();
// }

// class _GuidedcoachingsecondlevelState extends State<Guidedcoachingsecondlevel> {
//   final GuidedActivities _guidedActivities = GuidedActivities();
//   bool _isLoading = true;
//   List<Map<String, dynamic>> trainingData = [];

// @override
//   void initState() {
//     super.initState();
//     _fetchTrainings(widget.category["trainingIds"]); // Fetch data on widget load
//   }

//   Future<void> _fetchTrainings(List<String> ids) async {
//     trainingData = await _guidedActivities.fetchTrainings(ids);
//     setState(() {
//       _isLoading = false; // Update UI after fetching data
//     });
//   }

//   final List<Map<String, String>> tilesData = [
//     {'url': 'assets/images/sample.jpg', 'title': 'Exercise 1', 'time': '3 min'},
//     {
//       'url': 'assets/images/sample2.jpg',
//       'title': 'Exercise 2',
//       'time': '9 min'
//     },
//     {
//       'url': 'assets/images/sample3.jpg',
//       'title': 'Exercise 3',
//       'time': '13 min'
//     },
//     {
//       'url': 'assets/images/sample.jpg',
//       'title': 'Exercise 4',
//       'time': '23 min'
//     },
//     {'url': 'assets/images/login.jpg', 'title': 'Exercise 5', 'time': '33 min'},
//     {
//       'url': 'assets/images/sample2.jpg',
//       'title': 'Exercise 6',
//       'time': '31 min'
//     },
//     {
//       'url': 'assets/images/sample3.jpg',
//       'title': 'Exercise 7',
//       'time': '33 min'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//       child: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(widget.category["bigImageUrl"]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // CustomScrollView with a pinned SliverAppBar
//           CustomScrollView(
//             physics: BouncingScrollPhysics(),
//             slivers: [
//               // Pinned SliverAppBar
//               SliverAppBar(
//                 pinned: true,
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 expandedHeight: 100,
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Text(
//                     widget.category["name"],
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               // Content List
//               SliverPadding(
//                 padding: const EdgeInsets.only(top: 200),
//                 sliver: SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (BuildContext context, int index) {
//                       final tile = tilesData[index];
//                       return Column(
//                         children: [
//                           Guidedcoachingtile(
//                             url: tile['url']!,
//                             title: tile['title']!,
//                             timestamp: tile['time']!,
//                             onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => VerticalStackedCardScreen(),
//                         ),
//                       );
//                     },
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       );
//                     },
//                     childCount: tilesData.length,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:fab/compenents/guidedcoachingtile.dart';
import 'package:fab/screens/stackcard.dart';
import 'package:fab/services/guided_activities.dart';
import 'package:flutter/material.dart';

class Guidedcoachingsecondlevel extends StatefulWidget {
  final String email;
  final Map<String, dynamic> category;

  const Guidedcoachingsecondlevel({
    super.key,
    required this.email,
    required this.category,
  });

  @override
  State<Guidedcoachingsecondlevel> createState() =>
      _GuidedcoachingsecondlevelState();
}

class _GuidedcoachingsecondlevelState extends State<Guidedcoachingsecondlevel> {
  final GuidedActivities _guidedActivities = GuidedActivities();
  bool _isLoading = true;
  List<Map<String, dynamic>> trainingData = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainings(widget.category["trainingIds"]); // Fetch data on widget load
  }

  Future<void> _fetchTrainings(List<dynamic> ids) async {
    trainingData = await _guidedActivities.fetchTrainings(ids.cast<String>());
    setState(() {
      _isLoading = false; // Update UI after fetching data
    });
  }

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
                image: NetworkImage(widget.category["bigImageUrl"]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            )
          else
            // CustomScrollView with a pinned SliverAppBar
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Pinned SliverAppBar
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.category["name"],
                      style: const TextStyle(
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
                        final training = trainingData[index];
                        return Column(
                          children: [
                            Guidedcoachingtile(
                              url: training['imageUrl'] ??
                                  'assets/images/default.jpg', // Fallback image
                              title: training['name'] ?? 'No Title',
                              timestamp:
                                  '${5 ?? 'N/A'} min', // Duration from data
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VerticalStackedCardScreen(training:  training),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                      childCount: trainingData.length,
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