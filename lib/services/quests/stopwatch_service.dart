// A wrapper around the stop watch package
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:afkcredits/app/app.logger.dart';

enum StopWatchMode { countUp, countDown }

class StopWatchService extends PausableService {
  final log = getLogger("StopWatchService");

  final bool isLapHours;
  final StopWatchMode mode;
  Function(int)? onChange;
  Function(int)? onChangeRawSecond;
  Function(int)? onChangeRawMinute;
  final VoidCallback? onEnded;

  bool get isRunning => _timer != null && _timer!.isActive;
  int get initialPresetTime => _initialPresetTime;
  int get getSecondTime => _second;

  // ! WARNING this should not change from 1000
  int timerDuration = 1000; // in ms
  Timer? _timer;
  int _startTimeAbsolute = 0;
  int _stopTimeAbsolute = 0;
  int _stopTimeRelative = 0;
  late int _presetTime;
  int _second = 0;
  late int _initialPresetTime;

  StopWatchService({
    this.isLapHours = true,
    this.mode = StopWatchMode.countUp,
    int presetMillisecond = 0,
    this.onChange,
    this.onChangeRawSecond,
    this.onChangeRawMinute,
    this.onEnded,
  }) {
    /// Set presetTime
    _presetTime = presetMillisecond;
    _initialPresetTime = presetMillisecond;
  }

  void listenToSecondTime({required void Function(int) callback}) {
    setOnChangeSecond(callback);
    startTimer();
  }

  void forceListenToSecondTime({required void Function(int) callback}) {
    setOnChangeSecond(callback);
    forceStartTimer();
  }

  @override
  void resume() {
    if (servicePaused == true) {
      log.v('Stopwatch listener resumed');
      resumeTimer();
      super.resume();
    }
  }

  @override
  void pause() {
    if (isRunning == true &&
        (servicePaused == null || servicePaused == false)) {
      log.v('Stopwatch listener paused');
      stopTimer();
      super.pause();
    }
  }

  void _increment(Timer timer) {
    if (mode == StopWatchMode.countUp) {
      final time = _getCountUpTime(timer.tick);
      periodicFunction(time);
    } else if (mode == StopWatchMode.countDown) {
      final time = _getCountDownTime(timer.tick);
      if (time == 0) {
        stopTimer();
        if (onEnded != null) {
          onEnded!();
        }
      }
    } else {
      throw Exception('No support mode');
    }
  }

  int _getCountUpTime(num tick) =>
      tick.toInt() * timerDuration + _stopTimeRelative + _presetTime;

  int _getCountDownTime(num tick) => max(
        _presetTime - (tick.toInt() * timerDuration + _stopTimeRelative),
        0,
      );

  void resumeTimer() {
    if (!isRunning) {
      _stopTimeRelative = _stopTimeRelative +
          (DateTime.now().millisecondsSinceEpoch - _stopTimeAbsolute);
      final time = _getCountUpTime(0);
      periodicFunction(time);
      // ^ otherwise the Timer.periodic function waits for a minute to execute the update!
      startTimer();
    }
  }

  void startTimer() {
    if (!isRunning) {
      _startTimeAbsolute = DateTime.now().millisecondsSinceEpoch;
      _timer =
          Timer.periodic(Duration(milliseconds: timerDuration), _increment);
    }
  }

  void forceStartTimer() {
    if (isRunning) {
      resetTimer();
    }
    if (!isRunning) {
      _startTimeAbsolute = DateTime.now().millisecondsSinceEpoch;
      _timer =
          Timer.periodic(Duration(milliseconds: timerDuration), _increment);
    }
  }

  void periodicFunction(int value) {
    final latestSecond = getRawSecond(value);
    if (_second != latestSecond) {
      _second = latestSecond;
      if (onChangeRawSecond != null) {
        onChangeRawSecond!(latestSecond);
      }
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _stopTimeRelative +=
        DateTime.now().millisecondsSinceEpoch - _startTimeAbsolute;
    _stopTimeAbsolute = DateTime.now().millisecondsSinceEpoch;
  }

  void resetTimer() {
    if (isRunning) {
      stopTimer();
    }
    _startTimeAbsolute = 0;
    _stopTimeRelative = 0;
    _stopTimeAbsolute = 0;
    _second = 0;
  }

  setOnChangeSecond(void Function(int)? onChangeSecond) {
    onChangeRawSecond = onChangeSecond;
  }

  void setPresetHoursTime(int value) =>
      setPresetTime(mSec: value * 3600 * 1000);
  void setPresetMinuteTime(int value) => setPresetTime(mSec: value * 60 * 1000);
  void setPresetSecondTime(int value) => setPresetTime(mSec: value * 1000);
  void setPresetTime({required int mSec}) {
    _presetTime += mSec;
  }

  void clearPresetTime() {
    if (mode == StopWatchMode.countUp) {
      _presetTime = _initialPresetTime;
    } else if (mode == StopWatchMode.countDown) {
      _presetTime = _initialPresetTime;
    } else {
      throw Exception('No support mode');
    }
  }

  static String getDisplayTime(
    int value, {
    bool hours = true,
    bool minute = true,
    bool second = true,
    bool milliSecond = true,
    String hoursRightBreak = ':',
    String minuteRightBreak = ':',
    String secondRightBreak = '.',
  }) {
    final hoursStr = getDisplayTimeHours(value);
    final mStr = getDisplayTimeMinute(value, hours: hours);
    final sStr = getDisplayTimeSecond(value);
    final msStr = getDisplayTimeMillisecond(value);
    var result = '';
    if (hours) {
      result += '$hoursStr';
    }
    if (minute) {
      if (hours) {
        result += hoursRightBreak;
      }
      result += '$mStr';
    }
    if (second) {
      if (minute) {
        result += minuteRightBreak;
      }
      result += '$sStr';
    }
    if (milliSecond) {
      if (second) {
        result += secondRightBreak;
      }
      result += '$msStr';
    }
    return result;
  }

  static String getDisplayTimeHours(int mSec) {
    return getRawHours(mSec).floor().toString().padLeft(2, '0');
  }

  static String getDisplayTimeMinute(int mSec, {bool hours = false}) {
    if (hours) {
      return getMinute(mSec).floor().toString().padLeft(2, '0');
    } else {
      return getRawMinute(mSec).floor().toString().padLeft(2, '0');
    }
  }

  static String getDisplayTimeSecond(int mSec) {
    final s = (mSec % 60000 / 1000).floor();
    return s.toString().padLeft(2, '0');
  }

  static String getDisplayTimeMillisecond(int mSec) {
    final ms = (mSec % 1000 / 10).floor();
    return ms.toString().padLeft(2, '0');
  }

  static int getRawHours(int milliSecond) =>
      (milliSecond / (3600 * 1000)).floor();

  static int getMinute(int milliSecond) =>
      (milliSecond / (60 * 1000) % 60).floor();

  static int getRawMinute(int milliSecond) => (milliSecond / 60000).floor();

  static int getRawSecond(int milliSecond) => (milliSecond / 1000).floor();

  static int getMilliSecFromHour(int hour) => (hour * (3600 * 1000)).floor();

  static int getMilliSecFromMinute(int minute) => (minute * 60000).floor();

  static int getMilliSecFromSecond(int second) => (second * 1000).floor();

  String durationString(int? value) {
    if (value == null) return "00:00:00";
    int h = value ~/ 3600;
    int m = ((value - h * 3600)) ~/ 60;
    int s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "" + h.toString() : h.toString();
    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();
    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();
    String result = "$hourLeft" + ":" + "$minuteLeft" + ":" + "$secondsLeft";
    return result;
  }

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
