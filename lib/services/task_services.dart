import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab/models/task.dart';
import 'dart:async';

class TaskServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  Stream<QuerySnapshot> getTasks() {
    return _firestore.collection('predefinedTasks').snapshots();
  }

Stream<List<DocumentSnapshot>> getAddTasks(String userEmail) async* {
  print(userEmail);
    // Fetch tester tasks stream
    var testerTasksStream = _firestore
      .collection('testers')
      .doc(userEmail)
      .collection('tasks')
      .snapshots();

  // Fetch predefined tasks stream
  var predefinedTasksStream = _firestore
      .collection('predefinedTasks')
      .snapshots();

  // Listen to the streams
  await for (var testerSnapshot in testerTasksStream) {
    // Get predefined tasks when tester tasks data is available
    var predefinedSnapshot = await predefinedTasksStream.first;

    // Create lists to store tasks
    List<DocumentSnapshot> combinedTasks = [];
    List<DocumentSnapshot> testerTasks = testerSnapshot.docs;
    List<DocumentSnapshot> predefinedTasks = predefinedSnapshot.docs;

    // Add all tester tasks to the combined list
    combinedTasks.addAll(testerTasks);
    print(combinedTasks);
    print(testerTasks);
    print(predefinedTasks);
    // Filter out predefined tasks that are already in tester tasks based on objectID
    for (var predefinedTask in predefinedTasks) {
      print(predefinedTask['objectID']);
      print(predefinedTask['isdailyroutine']);
      if (!testerTasks.any((task) => task['objectID'] == predefinedTask['objectID'])) {
        print("IN");
        print(predefinedTask['objectID']);
      print(predefinedTask['isdailyroutine']);
        combinedTasks.add(predefinedTask);
      }
      print("OUT");
    }

    print("Combined Tasks:");
    combinedTasks.forEach((task) {
      print(task['objectID']); // Print objectID of combined tasks
      print(task['isdailyroutine']);
    });

    // Yield the combined list of tasks as a stream
    yield combinedTasks;
    }
  }



  Future<void> addTask(
  String userEmail,
  String name,
  String descriptionHtml,
  String objectID,
  String animationLink,
  String audioLink,
  String backgroundLink,
  String iconLink,
  bool isdailyroutine,
  bool iscompleted,
) async {
  Task newtask = Task(
    name: name,
    descriptionHtml: descriptionHtml,
    objectID: objectID,
    animationLink: animationLink,
    audioLink: audioLink,
    backgroundLink: backgroundLink,
    iconLink: iconLink,
    isdailyroutine: isdailyroutine,
    iscompleted: iscompleted,
  );

    await _firestore.collection('testers').doc(userEmail).collection('tasks').add(newtask.toMap());
  }

  Future<void> deleteTask(String id,String userEmail) async {
    await _firestore
        .collection('testers').doc(userEmail).collection('tasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
  }

  Future<bool> updateTasks(bool isadded, String id,String userEmail) async {
    await FirebaseFirestore.instance
        // .collection('predefinedTasks')
        .collection('testers').doc(userEmail).collection('tasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({'isdailyroutine': isadded});
      }
    });
    return true;
  }

  Stream<QuerySnapshot> getdailyTasks(String userEmail) {
    return _firestore.collection('testers').doc(userEmail).collection('tasks').snapshots();
  }

//   Stream<QuerySnapshot> getdailyTasks(String userEmail) {
//   return _firestore
//       .collection('testers')
//       .doc(userEmail)
//       .collection('tasks')
//       .where('taskPlaceholder', isNull: true) // Exclude docs with 'placeholder' field
//       .snapshots();
// }

  Future<void> updateTaskStatus(bool iscompleted, String id,String userEmail) async {
    await FirebaseFirestore.instance
        .collection('testers').doc(userEmail).collection('tasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({'iscompleted': iscompleted});
      }
    });
  }

  Future<int> getTotalUserTasks(String userEmail) async {
    var _querysnapshot = await _firestore.collection('testers').doc(userEmail).collection('tasks').get();
    return _querysnapshot.docs.length;
  }
}
