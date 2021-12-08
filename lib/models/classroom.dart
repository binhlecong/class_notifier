import 'package:flutter/material.dart';

class Classroom {
  static const List<String> dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  int? id;
  String? title;
  String? description;
  int? alarmBefore;
  DateTime? dateTime;
  int? weekDays;
  String? url;
  int? importance;

  Classroom();

  Classroom.fromParams(String title, String description, int alarmBefore,
      DateTime dateTime, int weekDays, String url, int importance) {
    this.title = title;
    this.description = description;
    this.alarmBefore = alarmBefore;
    this.dateTime = dateTime;
    this.weekDays = weekDays;
    this.url = url;
    this.importance = importance;
  }

  Classroom.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    alarmBefore = json['alarmBefore'];
    dateTime = DateTime.parse(json['dateTime']);
    weekDays = json['weekDays'];
    url = json['url'];
    importance = json['importance'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'alarmBefore': alarmBefore,
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

  bool isRepeatAt(int day) {
    return (weekDays! >> day & 1) == 1;
  }

  void setRepeatAt(int day, bool isRepeat) {
    if (isRepeat) {
      weekDays = weekDays! | 1 << day;
    } else {
      weekDays = weekDays! & ~(1 << day);
    }
  }

  String getWeekDaysStr() {
    String res = '';
    for (var i = 0; i < 7; i++) {
      if (isRepeatAt(i)) {
        res += dayNames[i] + '  ';
      }
    }
    if (res.isEmpty) {
      return 'One time event';
    }
    return res;
  }
}
