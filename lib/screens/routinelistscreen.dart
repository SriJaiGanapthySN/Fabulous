import 'package:fab/compenents/routinelist.dart';
import 'package:fab/compenents/routinelistheader.dart';
import 'package:fab/screens/taskreveal.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Routinelistscreen extends StatefulWidget {
  final String email; // Add this field

  const Routinelistscreen({Key? key, required this.email})
      : super(key: key); // Update constructor

  @override
  State<Routinelistscreen> createState() => _RoutinelistscreenState();
}

class _RoutinelistscreenState extends State<Routinelistscreen> {
  List<String> _habits = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAnimating = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateHabits(List<String> updatedHabits) {
    setState(() {
      _habits = updatedHabits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Wake Up Routine',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(height: 70),
            Row(
              children: [
                const Opacity(
                  opacity: 0.5, // Set the desired opacity value here
                  child: Icon(
                    Icons.alarm,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alarm',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Text(
                        _selectedTime.format(context),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: 166,
        flexibleSpace: Stack(
          children: [
            const Image(
              image: AssetImage('assets/images/RoutinesList.png'),
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              color: Colors.black.withOpacity(0.2),
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Routinelistheader(
                  number: _habits.length,
                  updateHabits: _updateHabits,
                  habits: _habits,
                  email: widget.email),
              const Divider(),
              Routinelist(habbit: _habits, email: widget.email),
            ],
          ),
          if (_isAnimating)
            Container(
              alignment: Alignment.bottomRight,
              child: Lottie.asset(
                'assets/animations/water.json', // Replace with your animation file
                width: 200,
                height: 200,
                repeat: false,
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Taskreveal(email: widget.email)),
            );
          },
          label: const Text(
            'Play',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.rocket,
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 143, 110, 239),
        ),
      ),
    );
  }
}
