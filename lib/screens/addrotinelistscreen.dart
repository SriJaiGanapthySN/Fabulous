import 'package:flutter/material.dart';
import 'package:fab/services/task_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

class Addrotinelistscreen extends StatefulWidget {
  final List<String> habits;
  final Function(List<String>) updateHabits;

  const Addrotinelistscreen(
      {super.key, required this.habits, required this.updateHabits});

  @override
  State<Addrotinelistscreen> createState() => _AddrotinelistscreenState();
}

class _AddrotinelistscreenState extends State<Addrotinelistscreen> {
  int taskCount = 0; // Variable to store task count

  // Method to fetch the task count
  Future<void> updateTaskCount() async {
    int count = await TaskServices().getTotalUserTasks();
    setState(() {
      taskCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    updateTaskCount(); // Initial task count fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Icon(
                  Icons.dashboard_sharp,
                  color: Colors.white,
                ),
                const SizedBox(width: 40),
                Text(
                  '$taskCount habits', // Displaying the updated task count
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.alarm, size: 32, color: Colors.white),
                SizedBox(width: 40),
                Text("None",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
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
      body: StreamBuilder(
        stream: TaskServices().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map<Widget>((document) {
                bool isAdded = document["isdailyroutine"];
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

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            iconPath,
                            width: 24,
                            height: 24,
                            // ignore: deprecated_member_use
                            color: isAdded ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(document['name'],
                                  textAlign: TextAlign.start)),
                          TextButton(
                            onPressed: () async {
                              setState(() async {
                                if (isAdded) {
                                  await TaskServices()
                                      .deleteTask(document["objectID"]);

                                  await TaskServices().updateTasks(
                                      !isAdded,
                                      document[
                                          "objectID"]); // Update local state
                                } else {
                                  await TaskServices().addTask(
                                    document['name'],
                                    document['descriptionHtml'],
                                    document['objectID'],
                                    document['iscompleted'],
                                  );
                                  await TaskServices().updateTasks(
                                      !isAdded, document["objectID"]);
                                }
                                updateTaskCount();
                              });
                            },
                            child: Text(
                              isAdded ? 'Remove' : 'Add',
                              style: TextStyle(
                                color: isAdded ? Colors.red : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
