import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:flutter/material.dart';

/// Stops and start long running services
// @see: https://www.filledstacks.com/post/flutter-application-life-cycle-management/

class LifeCycleManager extends StatefulWidget {
  final Widget child;

  LifeCycleManager({Key? key, required this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final ScreenTimeService screenTimeService = locator<ScreenTimeService>();
  List<PausableService? Function()> servicesToManage = [];

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    servicesToManage.add(() {
      if (!_questTestingService.isRecordingLocationData) {
        return locator<GeolocationService>();
      } else {
        return null;
      }
    });
    servicesToManage.add(() => locator<StopWatchService>());
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    servicesToManage.forEach(
      (service) {
        if (state == AppLifecycleState.resumed) {
          service()?.resume();
        } else {
          service()?.pause();
        }
      },
    );
  }
}
