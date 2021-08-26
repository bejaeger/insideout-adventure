// A wrapper around the stop watch package

import 'dart:async';

import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:afkcredits/app/app.logger.dart';

class StopWatchService {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  StreamSubscription? _streamSubscription;
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

  void listenToSecondTime({required void Function(int) callback}) {
    if (_streamSubscription == null) {
      _streamSubscription = _stopWatchTimer.secondTime.listen((value) {
        callback(value);
        log.v('secondTime $value');
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
}
