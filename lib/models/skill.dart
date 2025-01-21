class Skill {
  final String color;
  final int createdAt;
  final String goalId;
  final String iconUrl;
  final String iosIconUrl;
  final String objectId;
  final int position;
  final String skillTrackId;
  final String title;
  final int updatedAt;

  // Constructor
  Skill({
    required this.color,
    required this.createdAt,
    required this.goalId,
    required this.iconUrl,
    required this.iosIconUrl,
    required this.objectId,
    required this.position,
    required this.skillTrackId,
    required this.title,
    required this.updatedAt,
  });

  // Factory method to create Skill object from map
  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      color: map['color'] as String,
      createdAt: map['createdAt'] as int,
      goalId: map['goalId'] as String,
      iconUrl: map['iconUrl'] as String,
      iosIconUrl: map['iosIconUrl'] as String,
      objectId: map['objectId'] as String,
      position: map['position'] as int,
      skillTrackId: map['skillTrackId'] as String,
      title: map['title'] as String,
      updatedAt: map['updatedAt'] as int,
    );
  }

  // Convert Skill object to map
  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'createdAt': createdAt,
      'goalId': goalId,
      'iconUrl': iconUrl,
      'iosIconUrl': iosIconUrl,
      'objectId': objectId,
      'position': position,
      'skillTrackId': skillTrackId,
      'title': title,
      'updatedAt': updatedAt,
    };
  }
}