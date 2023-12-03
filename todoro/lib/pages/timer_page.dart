import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importez cette dépendance

import '../widgets/round_button.dart';

class TimerPage extends StatefulWidget {
  final int WorkTime;
  final int breakTime;
  final int rounds;

  const TimerPage({
    Key? key,
    required this.WorkTime,
    required this.breakTime,
    required this.rounds,
  }) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  String _currentPeriod = 'Work';
  late int _timeLeft = widget.WorkTime;
  double _roundsCompleted = 0.0;
  bool _timing = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  void _startCountDown() {
    setState(() {
      _timing = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        setState(() {
          _roundsCompleted += 0.5;
        });
        if (_currentPeriod == 'Work' && _roundsCompleted < widget.rounds) {
          setState(() {
            _timeLeft = widget.breakTime;
            _currentPeriod = 'break';
          });
          // Notification lorsque la période "Work" atteint zéro
          Noti.showBigTextNotification(
            title: 'Countdown Finished',
            body: 'Your work countdown has reached zero.',
            fln: flutterLocalNotificationsPlugin,
          );
        } else if (_currentPeriod == 'break' &&
            _roundsCompleted < widget.rounds) {
          setState(() {
            _timeLeft = widget.WorkTime;
            _currentPeriod = 'Work';
          });
          // Notification lorsque la période "break" atteint zéro
          Noti.showBigTextNotification(
            title: 'Countdown Finished',
            body: 'Your break countdown has reached zero.',
            fln: flutterLocalNotificationsPlugin,
          );
        } else {
          _timer.cancel();
          // Notification lorsque tous les tours sont terminés
          Noti.showBigTextNotification(
            title: 'Countdown Finished',
            body: 'Your countdown has finished all rounds.',
            fln: flutterLocalNotificationsPlugin,
          );
        }
      }
    });
  }

  void _pauseCountDown() {
    setState(() {
      _timing = false;
      _timer.cancel();
    });
  }

  void _resetCountDown() {
    setState(() {
      _timeLeft = widget.WorkTime;
      _currentPeriod = 'Work';
      _roundsCompleted = 0.0;
      _timing = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _currentPeriod == 'Work'
              ? const <Color>[Color(0xff5aff15), Color(0xff00b712)]
              : const <Color>[Color(0xfffbd72b), Color(0xfff9484a)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                _currentPeriod,
                style: const TextStyle(color: Colors.white, fontSize: 26),
              ),
              (_timeLeft == 0) && (_roundsCompleted == widget.rounds)
                  ? const Text(
                      'DONE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 90,
                      ),
                    )
                  : Text(
                      '${(_timeLeft ~/ 60)}'.padLeft(2, '0') +
                          ':' +
                          '${_timeLeft % 60}'.padLeft(2, '0'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 90,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (_timeLeft == 0) && (_roundsCompleted == widget.rounds)
                      ? RoundButton(
                          text: 'Reset',
                          onPressedCallBack: _resetCountDown,
                        )
                      : _timing
                          ? RoundButton(
                              text: 'Pause',
                              onPressedCallBack: _pauseCountDown,
                            )
                          : RoundButton(
                              text: 'Start',
                              onPressedCallBack: _startCountDown,
                            ),
                  RoundButton(
                    text: 'Cancel',
                    onPressedCallBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(0, title, body, not);
  }
}
