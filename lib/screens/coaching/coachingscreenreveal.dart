import 'package:fab/components/coaching/coachingheader.dart';
import 'package:fab/screens/challenges/audio.dart';
import 'package:fab/screens/coaching/coachingPlay.dart';
import 'package:fab/services/coaching_service.dart';
import 'package:flutter/material.dart';
import '../../components/common/contentcard.dart';

class Coachingscreenreveal extends StatefulWidget {
  final String email;
  final String coachingSeriesId;
  final Map<String, dynamic> coachingSeries;

  const Coachingscreenreveal({
    super.key,
    required this.email,
    required this.coachingSeriesId,
    required this.coachingSeries,
  });

  @override
  State<Coachingscreenreveal> createState() => _Coachingscreenreveal();
}

class _Coachingscreenreveal extends State<Coachingscreenreveal> {
  final CoachingService _coachingService = CoachingService();

  bool _isLoading = true;
  List<Map<String, dynamic>> coachingData = [];

  @override
  void initState() {
    super.initState();
    _fetchMainCoaching(); // Fetch data on widget load
  }

  Future<void> _fetchMainCoaching() async {
    try {
      coachingData =
          await _coachingService.getCoachings(widget.coachingSeriesId);
    } catch (error) {
      debugPrint("Error fetching coaching data: $error");
    } finally {
      setState(() {
        _isLoading = false; // Update UI after fetching data
      });
    }
  }

  Color colorFromString(String colorString) {
    String hexColor = colorString.replaceAll('#', '');
    if (hexColor.length == 6) {
      return Color(int.parse('0xFF$hexColor'));
    } else {
      throw FormatException('Invalid color string format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFromString(widget.coachingSeries["color"]),
      appBar: AppBar(
        backgroundColor: colorFromString(widget.coachingSeries["color"]),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(coaching: widget.coachingSeries),
                  const SizedBox(height: 24),
                  // Dynamically generated coaching content cards
                  ...coachingData.map((coachingItem) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to a new screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Coachingplay(
                                  email: widget.email,
                                  coachingSeries: widget.coachingSeries,
                                  coachingData: coachingItem,
                                  coachings: coachingData,
                                ),
                              ),
                            );
                          },
                          child: ContentCard(
                            coachingSeries: widget.coachingSeries,
                            coaching: coachingItem,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
