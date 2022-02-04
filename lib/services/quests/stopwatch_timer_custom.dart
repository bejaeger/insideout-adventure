import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

// ------------------------------------------------------------
// ------------------------------------------------------------
// Stopwatch service adapted from stop_watch_timer (see pub.dev)
// ------------------------------------------------------------
// ------------------------------------------------------------

/// StopWatchRecord
class StopWatchRecord {
  StopWatchRecord({
    this.rawValue,
    this.hours,
    this.minute,
    this.second,
    this.displayTime,
  });
  int? rawValue;
  int? hours;
  int? minute;
  int? second;
  String? displayTime;
}

/// StopWatch ExecuteType
enum StopWatchExecute { start, stop, reset, lap }

/// StopWatchMode
enum StopWatchMode { countUp, countDown }

/// StopWatchTimer
class StopWatchTimer {
  StreamSubscription? _elapsedTimeSubscription;

  final bool isLapHours;
  final StopWatchMode mode;
  Function(int)? onChange;
  Function(int)? onChangeRawSecond;
  Function(int)? onChangeRawMinute;
  final VoidCallback? onEnded;
  final PublishSubject<int> _elapsedTime = PublishSubject<int>();

  // behavior subjects
  // final BehaviorSubject<int> _rawTimeController =
  //     BehaviorSubject<int>.seeded(0);
  // ValueStream<int> get rawTime => _rawTimeController;
  // final BehaviorSubject<int> _secondTimeController =
  //     BehaviorSubject<int>.seeded(0);
  // ValueStream<int> get secondTime => _secondTimeController;
  // final BehaviorSubject<int> _minuteTimeController =
  //     BehaviorSubject<int>.seeded(0);
  // ValueStream<int> get minuteTime => _minuteTimeController;
  // final BehaviorSubject<List<StopWatchRecord>> _recordsController =
  //     BehaviorSubject<List<StopWatchRecord>>.seeded([]);
  // ValueStream<List<StopWatchRecord>> get records => _recordsController;

  // getter
  bool get isRunning => _timer != null && _timer!.isActive;
  int get initialPresetTime => _initialPresetTime;
  int get secondTime => _second;

  /// Private
  int timerDuration = 1000; // in ms
  Timer? _timer;
  int _startTimeAbsolute = 0;
  int _stopTimeAbsolute = 0;
  int _stopTimeRelative = 0;
  late int _presetTime;
  int _second = 0;
  // int? _minute;
  // List<StopWatchRecord> _records = [];
  late int _initialPresetTime;

  // constructor
  StopWatchTimer({
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

    if (mode == StopWatchMode.countDown) {
      _elapsedTime.add(_presetTime);
    }
  }

  /// When finish running timer, it need to dispose.
  Future<void> dispose() async {
    _timer?.cancel();
    await _elapsedTime.close();
    // await _rawTimeController.close();
    // await _secondTimeController.close();
    // await _minuteTimeController.close();
    // await _recordsController.close();
  }

  /// Get display millisecond time.
  void setPresetHoursTime(int value) =>
      setPresetTime(mSec: value * 3600 * 1000);

  void setPresetMinuteTime(int value) => setPresetTime(mSec: value * 60 * 1000);

  void setPresetSecondTime(int value) => setPresetTime(mSec: value * 1000);

  /// Set preset time. 1000 mSec => 1 sec
  void setPresetTime({required int mSec}) {
    _presetTime += mSec;
    _elapsedTime.add(_presetTime);
  }

  void clearPresetTime() {
    if (mode == StopWatchMode.countUp) {
      _presetTime = _initialPresetTime;
      _elapsedTime.add(isRunning ? _getCountUpTime(_presetTime) : _presetTime);
    } else if (mode == StopWatchMode.countDown) {
      _presetTime = _initialPresetTime;
      _elapsedTime
          .add(isRunning ? _getCountDownTime(_presetTime) : _presetTime);
    } else {
      throw Exception('No support mode');
    }
  }

  void _increment(Timer timer) {
    if (mode == StopWatchMode.countUp) {
      _elapsedTime.add(_getCountUpTime(timer.tick));
    } else if (mode == StopWatchMode.countDown) {
      final time = _getCountDownTime(timer.tick);
      _elapsedTime.add(time);
      if (time == 0) {
        stop();
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

  void resume() {
    if (!isRunning) {
      _stopTimeRelative = _stopTimeRelative +
          (DateTime.now().millisecondsSinceEpoch - _stopTimeAbsolute);
      start();
    }
  }

  void start() {
    if (!isRunning) {
      _elapsedTimeSubscription = _elapsedTime.listen((value) {
        // _rawTimeController.add(value);
        // if (onChange != null) {
        //   onChange!(value);
        // }
        final latestSecond = getRawSecond(value);
        if (_second != latestSecond) {
          // _secondTimeController.add(latestSecond);
          _second = latestSecond;
          if (onChangeRawSecond != null) {
            onChangeRawSecond!(latestSecond);
          }
        }
        // final latestMinute = getRawMinute(value);
        // if (_minute != latestMinute) {
        //   _minuteTimeController.add(latestMinute);
        //   _minute = latestMinute;
        //   if (onChangeRawMinute != null) {
        //     onChangeRawMinute!(latestMinute);
        //   }
        // }
      });
      _startTimeAbsolute = DateTime.now().millisecondsSinceEpoch;
      _timer =
          Timer.periodic(Duration(milliseconds: timerDuration), _increment);
    }
  }

  void stop() {
    if (isRunning) {
      _timer!.cancel();
      _elapsedTimeSubscription?.cancel();
      _elapsedTimeSubscription = null;
      _timer = null;
      _stopTimeRelative +=
          DateTime.now().millisecondsSinceEpoch - _startTimeAbsolute;
      _stopTimeAbsolute = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void reset() {
    if (isRunning) {
      _timer?.cancel();
      _timer = null;
    }
    _startTimeAbsolute = 0;
    _stopTimeRelative = 0;
    _second = 0;
    // _minute = null;
    // _records = [];
    // _recordsController.add(_records);
    _elapsedTime.add(_presetTime);
  }

  setOnChangeSecond(void Function(int)? onChangeSecond) {
    onChangeRawSecond = onChangeSecond;
  }

  // void lap() {
  //   if (isRunning) {
  //     final rawValue = _rawTimeController.value;
  //     _records.add(StopWatchRecord(
  //       rawValue: rawValue,
  //       hours: getRawHours(rawValue),
  //       minute: getRawMinute(rawValue),
  //       second: getRawSecond(rawValue),
  //       displayTime: getDisplayTime(rawValue, hours: isLapHours),
  //     ));
  //     _recordsController.add(_records);
  //   }
  // }

  // ----------------------------------------------------------------
  // static functions

  /// Get display time.
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

  /// Get display hours time.
  static String getDisplayTimeHours(int mSec) {
    return getRawHours(mSec).floor().toString().padLeft(2, '0');
  }

  /// Get display minute time.
  static String getDisplayTimeMinute(int mSec, {bool hours = false}) {
    if (hours) {
      return getMinute(mSec).floor().toString().padLeft(2, '0');
    } else {
      return getRawMinute(mSec).floor().toString().padLeft(2, '0');
    }
  }

  /// Get display second time.
  static String getDisplayTimeSecond(int mSec) {
    final s = (mSec % 60000 / 1000).floor();
    return s.toString().padLeft(2, '0');
  }

  /// Get display millisecond time.
  static String getDisplayTimeMillisecond(int mSec) {
    final ms = (mSec % 1000 / 10).floor();
    return ms.toString().padLeft(2, '0');
  }

  /// Get Raw Hours.
  static int getRawHours(int milliSecond) =>
      (milliSecond / (3600 * 1000)).floor();

  /// Get Raw Minute. 0 ~ 59. 1 hours = 0.
  static int getMinute(int milliSecond) =>
      (milliSecond / (60 * 1000) % 60).floor();

  /// Get Raw Minute
  static int getRawMinute(int milliSecond) => (milliSecond / 60000).floor();

  /// Get Raw Second
  static int getRawSecond(int milliSecond) => (milliSecond / 1000).floor();

  /// Get milli second from hour
  static int getMilliSecFromHour(int hour) => (hour * (3600 * 1000)).floor();

  /// Get milli second from minute
  static int getMilliSecFromMinute(int minute) => (minute * 60000).floor();

  /// Get milli second from second
  static int getMilliSecFromSecond(int second) => (second * 1000).floor();
}
