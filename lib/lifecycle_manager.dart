import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

/// Stop and start long running services
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
  final NavigationService _navigationService = locator<NavigationService>();
  List<PausableService? Function()> servicesToManage = [];

  // Get all services
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

    // HACKY SOLUTION!
    // if (screenTimeService.scheduledScreenTimeSession != null) {
    //   print(
    //       "LIFECYCLE MANAGER: Waiting for screen time start counter to execute");
    //   // await Future.delayed(Duration(seconds: screenTimeService.counter));
    //   if (state != AppLifecycleState.resumed) {
    //     if (screenTimeService.scheduledScreenTimeSession != null) {
    //       await NotificationsService()
    //           .maybeCreatePermanentIsUsingScreenTimeNotification(
    //               session: screenTimeService.scheduledScreenTimeSession!);
    //     }
    //     if (screenTimeService.scheduledScreenTimeSession != null) {
    //       await NotificationsService()
    //           .maybeCreateScheduledIsUsingScreenTimeNotification(
    //               session: screenTimeService.scheduledScreenTimeSession!);
    //     }
    //     screenTimeService.scheduledScreenTimeSession = null;
    //   }
    // }
  }
}
