import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab/services/task_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Routinelist extends StatefulWidget {
  Routinelist({super.key, required this.habbit, required this.email});

  List<String> habbit;
  final String email;

  @override
  State<Routinelist> createState() => _RoutinelistState();
}

class _RoutinelistState extends State<Routinelist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.6, // Set a specific height
      child: StreamBuilder<QuerySnapshot>(
          stream: TaskServices().getdailyTasks(widget.email),
          builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return const Center(child: Text('No Data Available'));
  }
  
  return ListView(
    children: snapshot.data!.docs.map<Widget>((document) {
      bool isChecked = document['iscompleted'] ?? false;
      String iconPath = document['iconLink'] ?? '';
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.network(
                    iconPath,
                    width: 24,
                    height: 24,
                    color: isChecked ? Colors.green : Colors.black,
                  ),
                  const SizedBox(width: 40),
                  Text(document['name'] ?? '',
                      style: const TextStyle(fontSize: 18, color: Colors.black)),
                ],
              ),
              Checkbox(
                value: isChecked,
                activeColor: Colors.green,
                onChanged: (bool? value) async {
                  if (value != null) {
                    await TaskServices()
                        .updateTaskStatus(value, document['objectID'],widget.email);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList(),
  );
})
    );
  }
}
