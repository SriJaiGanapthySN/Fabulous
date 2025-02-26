import 'package:fab/components/addJourneyTile.dart';
import 'package:fab/components/guidedcoachingtile.dart';
import 'package:fab/services/journey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddJourneyScreen extends StatefulWidget {
  final String email;
  const AddJourneyScreen({super.key, required this.email});

  @override
  State<AddJourneyScreen> createState() => _AddJourneyState();
}

class _AddJourneyState extends State<AddJourneyScreen> {
  final JourneyService _journeyService = JourneyService();
  bool _isLoading = true;
  List<Map<String, dynamic>> journeys = [];

  Future<void> getJourneys() async {
    try {
      final journey = await _journeyService.fetchJourneys();
      if (journey != null) {
        setState(() {
          journeys = journey;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching journey: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getJourneys();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Set the status bar color to red
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.red,
    //   statusBarIconBrightness: Brightness.light,
    // ));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Journeys",
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Dynamic font size
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : journeys.isEmpty
              ? const Center(
                  child: Text(
                    'No Journeys Found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: journeys.length,
                  itemBuilder: (context, index) {
                    final tile = journeys[index];
                    return Column(
                      children: [
                        AddJourneyTile(
                          tile: tile,
                          email: widget.email,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    );
                  },
                ),
    );
  }
}
