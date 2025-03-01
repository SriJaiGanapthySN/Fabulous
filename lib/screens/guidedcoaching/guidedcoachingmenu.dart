import 'package:fab/components/common/mygridtile.dart';
import 'package:fab/screens/guidedcoaching/guidedcoachingsecondlevel.dart';
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
    // Get screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculate the crossAxisCount based on screen width
    final int crossAxisCount = screenWidth > 600
        ? 3 // Tablets or larger screens
        : 2; // Phones

    // Calculate tile height based on available screen height
    final double tileHeight = screenHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guides',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: screenWidth / (tileHeight * crossAxisCount),
              ),
              padding: const EdgeInsets.all(5),
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
                        builder: (context) => Guidedcoachingsecondlevel(
                          email: widget.email,
                          category: category,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
