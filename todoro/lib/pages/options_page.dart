import 'package:flutter/material.dart';

import '../widgets/time_picker.dart';
import '../widgets/round_picker.dart';
import 'timer_page.dart';
import '../widgets/round_button.dart';

// Page for user to choose Work/break time and number of rounds
class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  int _WorkMinutes = 0;
  int _WorkSeconds = 0;
  int _breakMinutes = 0;
  int _breakSeconds = 0;
  int _rounds = 0;

  void updateWork(int value, String unit) {
    if (unit == 'm') {
      setState(() => _WorkMinutes = value);
    } else if (unit == 's') {
      setState(() => _WorkSeconds = value);
    }
  }

  void updatebreak(int value, String unit) {
    if (unit == 'm') {
      setState(() => _breakMinutes = value);
    } else if (unit == 's') {
      setState(() => _breakSeconds = value);
    }
  }

  void updateRounds(String direction) {
    if (direction == '-') {
      setState(() => _rounds--);
    } else if (direction == '+') {
      setState(() => _rounds++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff09c6f9), Color(0xff045de9)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Interval Timer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TimePicker(
                    title: 'Work',
                    minutes: _WorkMinutes,
                    seconds: _WorkSeconds,
                    onChangeCallBack: updateWork,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TimePicker(
                        title: 'break',
                        minutes: _breakMinutes,
                        seconds: _breakSeconds,
                        onChangeCallBack: updatebreak))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundPicker(
                  rounds: _rounds,
                  onPressedCallBack: updateRounds,
                ),
              ],
            ),
            RoundButton(
              text: 'GO',
              onPressedCallBack: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return TimerPage(
                        WorkTime: (_WorkMinutes * 60) + _WorkSeconds,
                        breakTime: (_breakMinutes * 60) + _breakSeconds,
                        rounds: _rounds,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
