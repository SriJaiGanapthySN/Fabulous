import 'package:flutter/material.dart';

class Journeysecondlevel extends StatefulWidget {
  const Journeysecondlevel({super.key});

  @override
  State<Journeysecondlevel> createState() => _JourneysecondlevelState();
}

class _JourneysecondlevelState extends State<Journeysecondlevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Small Change, Big Impact",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 50, color: Colors.white),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Card List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5, // Total number of cards
              itemBuilder: (context, index) {
                // Card Data
                final cardData = [
                  {
                    'title': 'Your Letter no. 1',
                    'subtitle': 'Mind the Gap',
                    'status': '1/5',
                    'completed': true,
                  },
                  {
                    'title': 'Goal',
                    'subtitle': 'Drink water',
                    'status': '2/5',
                    'completed': true,
                  },
                  {
                    'title': 'One-Time Action',
                    'subtitle': 'Prepare a Glass of Water',
                    'status': '3/5',
                    'completed': true,
                  },
                  {
                    'title': 'Daily Action',
                    'subtitle': 'Set a Reminder to Drink',
                    'status': '4/5',
                    'completed': false,
                  },
                  {
                    'title': 'MOTIVATOR',
                    'subtitle': 'Review Your Progress',
                    'status': '5/5',
                    'completed': false,
                  },
                ][index];

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(26),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text Section
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    cardData['title'] as String? ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    cardData['subtitle'] as String? ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 8),
                                      Text(
                                        cardData['completed'] == true
                                            ? 'COMPLETED'
                                            : 'READ',
                                        style: TextStyle(
                                          color: cardData['completed'] == true
                                              ? Colors.green
                                              : Colors.blue,
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
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardData['completed'] == true
                                ? Colors.green
                                : Colors.blue,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                            ),
                          ),
                          child: Text(
                            cardData['status']! as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
