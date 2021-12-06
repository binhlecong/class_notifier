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

  int _id = 0;
  String _title = "";
  String _description = "";
  DateTime _dateTime = DateTime.now();
  int _weekDays = 0;
  String _url = "";
  int _importance = 0;

  @override
  void initState() {
    if (widget.classroom != null) {
      _id = widget.classroom!.id ?? 0;
      _title = widget.classroom!.title ?? "";
      _description = widget.classroom!.description ?? "";
      _dateTime = widget.classroom!.dateTime ?? DateTime.now();
      _weekDays = widget.classroom!.weekDays ?? 1;
      _url = widget.classroom!.url ?? "";
      _importance = widget.classroom!.importance ?? 1;
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
              Text(_id.toString()),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'title',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'description',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  _description = value;
                },
              ),
              DateTimeField(
                decoration: InputDecoration(
                  labelText: _dateTime.toString(),
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

                    _dateTime = DateTimeField.combine(date, time);
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'week day',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  _weekDays = int.tryParse(value) ?? 1;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'url',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  _url = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 17),
                  hintText: 'importance',
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  _importance = int.tryParse(value) ?? 1;
                },
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
                                await _databaseHelper.deleteClassroom(_id);
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
                              if (widget.classroom == null) {
                                Classroom newEvent = Classroom.fromParams(
                                  _title,
                                  _description,
                                  _dateTime,
                                  _weekDays,
                                  _url,
                                  _importance,
                                );

                                _id = await _databaseHelper
                                    .insertClassroom(newEvent);
                              } else {
                                Classroom thisClassroom =
                                    await _databaseHelper.getClassroom(_id);
                                thisClassroom.title = _title;
                                thisClassroom.description = _description;
                                thisClassroom.dateTime = _dateTime;
                                thisClassroom.weekDays = _weekDays;
                                thisClassroom.url = _url;
                                thisClassroom.importance = _importance;

                                _id = await _databaseHelper
                                    .updateClassroom(thisClassroom);
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

  @override
  void dispose() {
    // TODO: dispose focus node if needed
    super.dispose();
  }
}
