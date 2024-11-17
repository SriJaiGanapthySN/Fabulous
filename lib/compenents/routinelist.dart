import 'package:fab/services/task_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Routinelist extends StatefulWidget {
  Routinelist({super.key, required this.habbit});

  List<String> habbit;

  @override
  State<Routinelist> createState() => _RoutinelistState();
}

class _RoutinelistState extends State<Routinelist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.6, // Set a specific height
      child: StreamBuilder(
          stream: TaskServices().getdailyTasks(),
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data!.docs.map<Widget>((document) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading state
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle errors
                } else if (!snapshot.hasData) {
                  return Text('No Data Available'); // Handle empty state
                }
                if (snapshot.hasData) {
                  bool isChecked = document['iscompleted'];
                  String iconPath;
                  switch (document['name']) {
                    case 'Eat a Great Breakfast':
                      iconPath = 'assets/images/breakfast.svg';
                      break;
                    case 'Write in My Journal':
                      iconPath = 'assets/images/journal.svg';
                      break;
                    case 'Yoga':
                      iconPath = 'assets/images/yoga.svg';
                      break;
                    default:
                      iconPath = 'assets/images/breakfast.svg';
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                iconPath,
                                width: 24,
                                height: 24,
                                // ignore: deprecated_member_use
                                color: isChecked ? Colors.green : Colors.black,
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Text(document['name'],
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ],
                          ),
                          Checkbox(
                            value: isChecked,
                            activeColor: Colors.green,
                            onChanged: (bool? value) async {
                              await TaskServices().updateTaskStatus(
                                  value!, document['objectID']);
                              setState(() {
                                isChecked = !value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }).toList(),
            );
          }),
    );
  }
}
