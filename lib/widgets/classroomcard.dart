import 'package:class_notifier/models/classroom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date format

class ClassroomCard extends StatelessWidget {
  final Classroom classroom;
  const ClassroomCard({Key? key, required this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.only(
            right: 14.0,
          ),
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Row(
            children: [
              Container(
                color: classroom.getColorImportance(),
                width: 16.0,
                height: double.infinity,
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        classroom.title!,
                        style: const TextStyle(
                          color: Color(0xFF211551),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        classroom.description!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white38,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        classroom.getWeekDays(),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: 80.0,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Center(
                  child: Text(
                    formatter.format(
                      classroom.dateTime ?? DateTime.now(),
                    ),
                    style: const TextStyle(
                      fontSize: 28.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
