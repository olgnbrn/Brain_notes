import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInitialize = AndroidInitializationSettings('app_icon');
    var darwinInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: androidInitialize, iOS: darwinInitialize);
    localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    tz.TZDateTime scheduledTime = tz.TZDateTime.parse(tz.local, _timeController.text);
    var androidDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.max, priority: Priority.high);
    var darwinDetails = DarwinNotificationDetails();
    var generalNotificationDetails = NotificationDetails(
        android: androidDetails, iOS: darwinDetails);

    await localNotificationsPlugin.zonedSchedule(
      0,
      'Hatırlatıcı',
      'Bu bir hatırlatıcıdır!',
      scheduledTime,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hatırlatıcı Ayarla'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Hatırlatıcı Zamanı (yyyy-mm-dd hh:mm)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Hatırlatıcı Ayarla'),
            ),
          ],
        ),
      ),
    );
  }
}
