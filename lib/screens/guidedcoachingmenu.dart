// import 'package:fab/compenents/mygridtile.dart';
// import 'package:fab/screens/guidedcoachingsecondlevel.dart';
// import 'package:fab/services/guided_activities.dart';
// import 'package:flutter/material.dart';

// class Guidedcoachingmenu extends StatelessWidget {
//   final String email;
//   final GuidedActivities _GuidedActivities = GuidedActivities();
//   final List<Map<String, dynamic>> categoryData=[];

//   @override
//   void init() {
//     _GuidedActivities.fetchCategories();
//   }
  
//   const Guidedcoachingmenu({super.key, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Guides',
//             style: TextStyle(
//                 fontSize: 25, fontWeight: FontWeight.bold, color: Colors.pink),
//           ),
//         ),
//         body: GridView(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//           children: [
//             Mygridtile(url: "assets/images/login.jpg", title: "Exersice",onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Guidedcoachingsecondlevel(email: email),
//                         ),
//                       );
//                     },),
//             Mygridtile(url: "assets/images/sample.jpg", title: "Meditation"),
//             Mygridtile(url: "assets/images/sample2.jpg", title: "Yoga"),
//             Mygridtile(url: "assets/images/sample3.jpg", title: "Diet"),
//           ],
//         ));
//   }
// }


import 'package:fab/compenents/mygridtile.dart';
import 'package:fab/screens/guidedcoachingsecondlevel.dart';
import 'package:fab/services/guided_activities.dart';
import 'package:flutter/material.dart';

class Guidedcoachingmenu extends StatefulWidget {
  final String email;

  const Guidedcoachingmenu({super.key, required this.email});

  @override
  State<Guidedcoachingmenu> createState() => _GuidedcoachingmenuState();
}

class _GuidedcoachingmenuState extends State<Guidedcoachingmenu> {
  final GuidedActivities _guidedActivities = GuidedActivities();
  List<Map<String, dynamic>> categoryData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch data on widget load
  }

  Future<void> _fetchCategories() async {
    categoryData = await _guidedActivities.fetchCategories();
    setState(() {
      _isLoading = false; // Update UI after fetching data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guides',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.pink),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: categoryData.length,
              itemBuilder: (context, index) {
                final category = categoryData[index];
                return Mygridtile(
                  url: category['imageUrl'] ?? "assets/images/default.jpg",
                  title: category['name'] ?? "No Title",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Guidedcoachingsecondlevel(email: widget.email,category:category),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}