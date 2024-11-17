class Task {
  final String name;
  final String description;
  final String objectID;
  final bool iscompleted;

  Task({
    required this.name,
    required this.description,
    required this.objectID,
    this.iscompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'objectID': objectID,
      'iscompleted': iscompleted,
    };
  }
}
