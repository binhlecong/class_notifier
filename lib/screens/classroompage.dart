import 'package:class_notifier/database/db_helper.dart';
import 'package:class_notifier/models/classroom.dart';
import 'package:class_notifier/screens/qr_generate.dart';
import 'package:class_notifier/notification/notification_api.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:class_notifier/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassroomPage extends StatefulWidget {
  final Classroom? classroom;
  ClassroomPage({required this.classroom});

  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  Classroom? classroom = null;

  @override
  void initState() {
    if (widget.classroom == null) {
      classroom = Classroom.fromParams(
          '<No title>',
          '<No description>',
          0,
          DateTime.now().add(const Duration(minutes: 1)),
          0,
          'https://www.google.com/',
          0);
    } else {
      classroom = widget.classroom!;
    }

    NotificationApi.init(initScheduled: true);
    listenNotifications();

    super.initState();
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickNotification);
  }

  void onClickNotification(String? payload) {
    _launchURL(payload!);
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: widget.classroom != null ? _pushQRGenerator : null,
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              size: 35,
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: const Text('Notify'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            DateTimeField(
              decoration: const InputDecoration(
                labelText: 'Date & Time',
                isDense: true,
                contentPadding: EdgeInsets.all(2),
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? classroom!.dateTime!,
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentValue ?? classroom!.dateTime!,
                      ));

                  classroom!.dateTime = DateTimeField.combine(date, time);
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildDaySelector('Mo', 0),
                buildDaySelector('Tu', 1),
                buildDaySelector('We', 2),
                buildDaySelector('Th', 3),
                buildDaySelector('Fr', 4),
                buildDaySelector('Sa', 5),
                buildDaySelector('Su', 6),
              ],
            ),
            const SizedBox(height: 15.0),
            TextField(
                autofocus: true,
                controller: TextEditingController()
                  ..text = widget.classroom == null ? '' : classroom!.title!,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.topic_outlined),
                  filled: true,
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  classroom!.title = value;
                }),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              controller: TextEditingController()
                ..text = widget.classroom == null ? '' : classroom!.url!,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link_rounded),
                filled: true,
                labelText: 'URL',
              ),
              onChanged: (value) {
                classroom!.url = value;
              },
            ),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              controller: TextEditingController()
                ..text = classroom!.alarmBefore!.toString(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.notifications_active_outlined),
                filled: true,
                labelText: 'Notify before class (minutes)',
              ),
              onChanged: (value) {
                classroom!.alarmBefore = int.tryParse(value) ?? 1;
              },
            ),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              maxLines: null,
              controller: TextEditingController()
                ..text =
                    widget.classroom == null ? '' : classroom!.description!,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description_outlined),
                filled: true,
                labelText: 'Description',
              ),
              onChanged: (value) {
                classroom!.description = value;
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Importance level'
            ),
            Slider(
              value: classroom!.importance!.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  classroom!.importance = newValue.toInt();
                });
              },
              divisions: 4,
              label: '${classroom!.importance}',
              min: 0,
              max: 4,
            ),
            const SizedBox(height: 15.0),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: const Text('DELETE'),
                  onPressed: () async {
                    if (widget.classroom != null) {
                      await _databaseHelper.deleteClassroom(classroom!.id!);
                      NotificationApi.cancelNotification(classroom!.id!);
                    }
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('SAVE'),
                  onPressed: () async {
                    int _id = 0;
                    if (widget.classroom == null || classroom!.id == null) {
                      _id = await _databaseHelper.insertClassroom(classroom!);
                    } else {
                      _id = await _databaseHelper.updateClassroom(classroom!);
                      NotificationApi.cancelNotification(_id);
                    }

                    NotificationApi.scheduleNotification(
                      id: _id,
                      title: classroom!.title!,
                      body: classroom!.description!,
                      payload: classroom!.url,
                      scheduledDate: classroom!.dateTime!.subtract(Duration(
                        minutes: classroom!.alarmBefore!,
                      )),
                    );

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
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
      child: SizedBox.fromSize(
        size: const Size.fromRadius(20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: isRepeated ? kGreen300 : Colors.white70),
          child: Center(
              child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              color: isRepeated ? Colors.white : kBrown900,
            ),
          )),
        ),
      ),
    );
  }

  void _pushQRGenerator() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GeneratePage(classroom: classroom)));
  }
}
