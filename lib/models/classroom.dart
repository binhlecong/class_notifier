import 'package:flutter/material.dart';

class Classroom {
  final int id;
  final String title;
  final DateTime dateTime;
  final int weekDays;
  final String description;
  final String url;
  final int importance;

  Classroom({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.weekDays,
    required this.url,
    required this.importance,
  });

  factory Classroom.fromMap(Map<String, dynamic> json) => Classroom(
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

  Color getColorImportance() {
    switch (importance) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
