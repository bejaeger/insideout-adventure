// A wrapper around the stop watch package

import 'dart:async';

import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:afkcredits/app/app.logger.dart';

class StopWatchService {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  StreamSubscription? _streamSubscription;
  StreamSubscription<int>? _timerSubscription;

  String _hoursStr = '00';
  String _minutesStr = '00';
  String _secondsStr = '00';

  final log = getLogger("StopWatchService");
  void startTimer() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void stopTimer() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  void resetTimer() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  int getSecondTime() {
    return _stopWatchTimer.secondTime.value;
  }

  void listenToSecondTime({required Future Function(int) callback}) {
    if (_streamSubscription == null) {
      _streamSubscription = _stopWatchTimer.secondTime.listen((value) {
        callback(value);
        // if (value % 10 == 0) log.v('secondTime $value');
      });
    } else {
      log.w("second time already listened to!");
    }
  }

  void cancelListener() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void pauseListener() {
    _streamSubscription?.pause();
  }

  void resumeListener() {
    if (_streamSubscription != null && _streamSubscription!.isPaused) {
      _streamSubscription!.resume();
    }
  }

  /////// Timers Services added By Harguilar
  bool flag = true;
  Stream<int>? timerStream;
  // StreamSubscription<int>? timerSubscription;

  String get getHours => _hoursStr;
  String get getMinutes => _minutesStr;
  String get getSeconds => _secondsStr;

/*   void setHours({required String hours}) {
    _hoursStr = hours;
    print('Harguilar Number of Hours: $_hoursStr');
  }

  void setMinutes({required String minutes}) {
    _minutesStr = minutes;
    print('Harguilar Number of Minutes: $_minutesStr');
  }

  void setSeconds({required String seconds}) {
    _secondsStr = seconds;
    print('Harguilar Number of Seconds: $_secondsStr');
  } */

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      counter++;
      streamController!.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  void setTimerStreamSubscription(
      {required StreamSubscription<int> timerSubscription}) {
    _timerSubscription = timerSubscription;
  }

  StreamSubscription<int>? get getTimerSubscription => _timerSubscription;

  // Helper functions
  String secondsToHourMinuteSecondTime(int? value) {
    if (value == null) return "00:00:00";
    int h = value ~/ 3600;
    int m = ((value - h * 3600)) ~/ 60;
    int s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();
    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();
    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();
    String result =
        "$hourLeft" + "h" + " $minuteLeft" + "m" + " $secondsLeft" + "s";
    return result;
  }

  // Helper functions
  String secondsToMinuteSecondTime(int? value) {
    final result = secondsToHourMinuteSecondTime(value);
    final substring = result.substring(4);
    if (substring[0] == "0") {
      return substring.substring(1);
    } else {
      return substring;
    }
  }
}
