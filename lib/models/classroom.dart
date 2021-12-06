import 'package:flutter/material.dart';

class Classroom {
  int? id;
  String? title;
  DateTime? dateTime;
  int? weekDays;
  String? description;
  String? url;
  int? importance;

  Classroom();

  Classroom.fromParams(String title, String description, DateTime dateTime,
      int weekDays, String url, int importance) {
    this.title = title;
    this.description = description;
    this.dateTime = dateTime;
    this.weekDays = weekDays;
    this.url = url;
    this.importance = importance;
  }

  Classroom.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dateTime = DateTime.parse(json['dateTime']);
    weekDays = json['weekDays'];
    url = json['url'];
    importance = json['importance'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime!.toIso8601String(),
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
