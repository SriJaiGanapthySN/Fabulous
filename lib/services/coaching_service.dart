import 'package:cloud_firestore/cloud_firestore.dart';

class CoachingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getMainCoachings() async {
  try {
    // One-time fetch of documents where hidden == false
    QuerySnapshot snapshot = await _firestore
        .collection('coachingSeries')
        .where('hidden', isEqualTo: false)
        .get();

    // Convert the snapshot to a List of Maps
    List<Map<String, dynamic>> mainCoachings = [];
    for (var doc in snapshot.docs) {
      mainCoachings.add(doc.data() as Map<String, dynamic>);
    }

    // Sort the list by the 'position' field
    mainCoachings.sort((a, b) {
      // Assuming 'position' is a numeric field
      return (a['position'] as int).compareTo(b['position'] as int);
    });

    return mainCoachings;
  } catch (e) {
    print('Error fetching habits: $e');
    return []; // Returning an empty list in case of an error
  }
}

}