import 'package:fab/screens/addrotinelistscreen.dart';
import 'package:flutter/material.dart';

class Routinelistheader extends StatefulWidget {
  final int number;
  final List<String> habits;
  final Function(List<String>) updateHabits;

  const Routinelistheader(
      {super.key,
      required this.number,
      required this.habits,
      required this.updateHabits});

  @override
  State<Routinelistheader> createState() => _RoutinelistheaderState();
}

class _RoutinelistheaderState extends State<Routinelistheader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_left,
                  color: Colors.red,
                  size: 34,
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              const Column(
                children: [Text('habits'), Text('Today')],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Addrotinelistscreen(
                        habits: widget.habits,
                        updateHabits: widget.updateHabits,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
        ],
      ),
    );
  }
}
