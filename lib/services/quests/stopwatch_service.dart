// A wrapper around the stop watch package

import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/quests/stopwatch_timer_custom.dart';

class StopWatchService extends PausableService {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  final log = getLogger("StopWatchService");

  // getter
  bool get isListening => _stopWatchTimer.isRunning;

  void startTimer() {
    _stopWatchTimer.start();
  }

  void stopTimer() {
    _stopWatchTimer.stop();
  }

  void resetTimer() {
    _stopWatchTimer.reset();
  }

  int getSecondTime() {
    return _stopWatchTimer.secondTime;
  }

  // int getMinuteTime() {
  //   return _stopWatchTimer.minuteTime.value;
  // }

  // int getHourTime() {
  //   return (_stopWatchTimer.minuteTime.value ~/ 60);
  // }

  void listenToSecondTime({required void Function(int) callback}) {
    _stopWatchTimer.setOnChangeSecond(callback);
    _stopWatchTimer.start();
  }

  @override
  void resume() {
    if (servicePaused == true) {
      log.v('Stopwatch listener resumed');
      _stopWatchTimer.resume();
      super.resume();
    }
  }

  @override
  void pause() {
    if (isListening == true &&
        (servicePaused == null || servicePaused == false)) {
      log.v('Stopwatch listener paused');
      _stopWatchTimer.stop();
      super.pause();
    }
  }

  void cancelListener() {
    _stopWatchTimer.stop();
  }

  // TODO: Delete deprecated code below
  /////// Timers Services added By Harguilar
  // bool flag = true;
  // Stream<int>? timerStream;

  // Stream<int> stopWatchStream() {
  //   StreamController<int>? streamController;
  //   Timer? timer;
  //   Duration timerInterval = Duration(seconds: 1);
  //   int counter = 0;

  //   void stopTimer() {
  //     if (timer != null) {
  //       timer!.cancel();
  //       timer = null;
  //       counter = 0;
  //       streamController!.close();
  //     }
  //   }

  //   void tick(_) {
  //     counter++;
  //     streamController!.add(counter);
  //     if (!flag) {
  //       stopTimer();
  //     }
  //   }

  //   void startTimer() {
  //     timer = Timer.periodic(timerInterval, tick);
  //   }

  //   streamController = StreamController<int>(
  //     onListen: startTimer,
  //     onCancel: stopTimer,
  //     onResume: startTimer,
  //     onPause: stopTimer,
  //   );

  //   return streamController.stream;
  // }

  // ---------------------------------------------------
  // Helper functions
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
