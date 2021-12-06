class ClassRoom {
  final int id;
  final String title;
  final DateTime dateTime;
  final int weekDays;
  final String description;
  final String url;
  final int importance;

  ClassRoom({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.weekDays,
    required this.url,
    required this.importance,
  });

  factory ClassRoom.fromMap(Map<String, dynamic> json) => ClassRoom(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dateTime: DateTime.parse(json['dateTime']),
        weekDays: json['weekDays'],
        url: json['url'],
        importance: json['importance'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'weekDays': weekDays,
        'url': url,
        'importance': importance,
      };
}
