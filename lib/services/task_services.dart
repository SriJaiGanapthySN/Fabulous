import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab/models/task.dart';

class TaskServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getTasks() {
    return _firestore.collection('predefinedTasks').snapshots();
  }

  Future<void> addTask(
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

    await _firestore.collection('userTasks').add(newtask.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _firestore
        .collection('userTasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
  }

  Future<bool> updateTasks(bool isadded, String id) async {
    await FirebaseFirestore.instance
        .collection('predefinedTasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({'isdailyroutine': isadded});
      }
    });
    return true;
  }

  Stream<QuerySnapshot> getdailyTasks() {
    return _firestore.collection('userTasks').snapshots();
  }

  Future<void> updateTaskStatus(bool iscompleted, String id) async {
    await FirebaseFirestore.instance
        .collection('userTasks')
        .where('objectID', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({'iscompleted': iscompleted});
      }
    });
  }

  Future<int> getTotalUserTasks() async {
    var _querysnapshot = await _firestore.collection('userTasks').get();
    return _querysnapshot.docs.length;
  }
}
