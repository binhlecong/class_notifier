import 'package:class_notifier/database/db_helper.dart';
import 'package:class_notifier/models/classroom.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassroomPage extends StatefulWidget {
  final Classroom? classroom;
  ClassroomPage({required this.classroom});

  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  final myController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  Classroom? classroom = null;

  @override
  void initState() {
    if (widget.classroom == null) {
      classroom = Classroom.fromParams(
          '<No title>', '<No description>', 0, DateTime.now(), 0, '', 1);
    } else {
      classroom = widget.classroom!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
          child: ListView(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'title',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  classroom!.title = value;
                },
                controller: TextEditingController()
                              ..text = classroom!.title!,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'description',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  classroom!.description = value;
                },
                controller: TextEditingController()
                              ..text = classroom!.description!,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'alarm before minutes:',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  classroom!.alarmBefore = int.tryParse(value) ?? 1;
                },
                controller: TextEditingController()
                              ..text = classroom!.alarmBefore!.toString(),
              ),
              DateTimeField(
                decoration: InputDecoration(
                  labelText: classroom!.dateTime!.toIso8601String(),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(2),
                ),
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ));

                    classroom!.dateTime = DateTimeField.combine(date, time);
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
              Row(
                children: [
                  buildDaySelector('Mon', 0),
                  buildDaySelector('Tue', 1),
                  buildDaySelector('Wed', 2),
                  buildDaySelector('Thu', 3),
                  buildDaySelector('Fri', 4),
                  buildDaySelector('Sat', 5),
                  buildDaySelector('Sun', 6),
                ],
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'url',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  classroom!.url = value;
                },
                controller: TextEditingController()
                              ..text = classroom!.url!,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'importance',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  classroom!.importance = int.tryParse(value) ?? 1;
                },
                controller: TextEditingController()
                              ..text = classroom!.importance!.toString(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            onPressed: () async {
                              if (widget.classroom != null) {
                                await _databaseHelper
                                    .deleteClassroom(classroom!.id!);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(
                              Icons.check,
                            ),
                            label: const Text('Save'),
                            onPressed: () async {
                              int _id = 0;
                              if (widget.classroom == null) {
                                _id = await _databaseHelper
                                    .insertClassroom(classroom!);
                              } else {
                                _id = await _databaseHelper
                                    .updateClassroom(classroom!);
                              }

                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildDaySelector(String name, int value) {
    bool isRepeated = classroom!.isRepeatAt(value);
    return GestureDetector(
      onTap: () {
        setState(() {
          classroom!.setRepeatAt(value, !isRepeated);
        });
      },
      child: SizedBox(
        width: 50,
        height: 40,
        child: Text(
          name,
          style: TextStyle(color: isRepeated ? Colors.red : Colors.grey),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: dispose focus node if needed
    super.dispose();
  }
}
