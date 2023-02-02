import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class CurrentQuestStatusInfo extends StatelessWidget {
  final DirectionStatus? directionStatus;
  final double currentDistance;
  final double previousDistance;
  final ActivatedQuest? activatedQuest;
  final bool isBusy;
  final bool isFirstDistanceCheck;
  final int numCheckpointsReached;
  final int numMarkers;

  const CurrentQuestStatusInfo(
      {Key? key,
      required this.activatedQuest,
      required this.directionStatus,
      required this.previousDistance,
      required this.currentDistance,
      required this.isFirstDistanceCheck,
      required this.numCheckpointsReached,
      required this.numMarkers,
      this.isBusy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: screenWidth(context) - 2 * kHorizontalPadding,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 15),
          //margin: const EdgeInsets.all(kHorizontalPadding),
          decoration: BoxDecoration(
            color: getDirectionStatusColor(directionStatus),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: getOtherStatusString(directionStatus) != null
              ? AfkCreditsText.successThree(
                  getOtherStatusString(directionStatus)!,
                  align: TextAlign.center)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AfkCreditsText.headingFour(
                          "Distance to checkpoint " +
                              (numCheckpointsReached + 1).toString() +
                              " / " +
                              numMarkers.toString(),
                        ),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         AfkCreditsText.headingFour(
                        //             numCheckpointsReached.toString() +
                        //                 " / " +
                        //                 numMarkers.toString()),
                        //       ],
                        //     ),
                        //     // AfkCreditsText.caption("Collected")
                        //   ],
                        // ),
                        // AfkCreditsText.body(
                        //     getDirectionStatusString(directionStatus)),
                      ],
                    ),
                    verticalSpaceTiny,
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(kActivityIcon,
                            width: 40,
                            color: directionStatus == DirectionStatus.closer
                                ? Colors.white
                                : kcPrimaryColor),
                        horizontalSpaceSmall,
                        Icon(Icons.arrow_forward,
                            size: 22, color: kcMediumGrey),
                        horizontalSpaceSmall,
                        Image.asset(kAFKCreditsLogoPath,
                            width: 38,
                            color: directionStatus == DirectionStatus.closer
                                ? Colors.white
                                : kcPrimaryColor),
                        AfkCreditsText.headingThree(" "),
                        horizontalSpaceSmall,
                        isBusy
                            ? AFKProgressIndicator(color: Colors.grey[500])
                            : AfkCreditsText.headingTwo(
                                !isFirstDistanceCheck
                                    ? "${currentDistance.toStringAsFixed(1)} m"
                                    : "?",
                              )
                      ],
                    ),
                  ],
                ),
        ),
        verticalSpaceSmall,
        AfkCreditsText.headingThree(getDirectionStatusString(directionStatus),
            align: TextAlign.center),
        // Text("Aktuelle Distanz",
        //     textAlign: TextAlign.center, style: textTheme(context).headline6),
        // Text("Last Distance",
        //     textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        // Text("${activatedQuest?.lastDistanceInMeters?.toStringAsFixed(1)} m",
        //     textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  String getDirectionStatusString(DirectionStatus? status) {
    if (status == null) return "Start to walk!";
    switch (status) {
      case DirectionStatus.closer:
        return "Getting Closer!";
      case DirectionStatus.further:
        return "Further away!";
      case DirectionStatus.notstarted:
        return "";
      case DirectionStatus.denied:
        return "";
      case DirectionStatus.checkingDistance:
        return "Checking distance...";
      case DirectionStatus.nearGoal:
        return "Tap the credits on the map";
      case DirectionStatus.nextNextMarker:
        return "Tap the credits on the map";
      case DirectionStatus.nextMarkerWaiting:
        return "Find the next checkpoint!";
      default:
        return "Start to walk!";
    }
  }

  String? getOtherStatusString(DirectionStatus? status) {
    if (status == null) return null;
    switch (status) {
      case DirectionStatus.nearGoal:
        return "Yippieh, you reached the finish line! " +
            Emojis.smile_partying_face;
      case DirectionStatus.nextNextMarker:
        return "Checkpoint found! " + Emojis.hand_clapping_hands;
      default:
        return null;
    }
  }

  Color getDirectionStatusColor(DirectionStatus? status) {
    if (status == null) return Colors.grey[200]!;
    switch (status) {
      case DirectionStatus.closer:
        return Colors.green.withOpacity(0.8);
      case DirectionStatus.further:
        return Colors.red.withOpacity(0.8);
      case DirectionStatus.denied:
        return Colors.grey[200]!;
      default:
        return Colors.grey[200]!.withOpacity(0.8);
    }
  }
}

class ReloadingWidget extends StatefulWidget {
  const ReloadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ReloadingWidget> createState() => _ReloadingWidgetState();
}

class _ReloadingWidgetState extends State<ReloadingWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  // ..repeat(reverse: true);
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: kCheckDistanceReloadDurationInSeconds),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 100,
          color: Colors.grey[200],
          width: 100,
          child: SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            axisAlignment: -1,
            // curve: Curves.fastOutSlowIn,
            child: Container(color: Colors.orange, width: 100),
            // constraints: BoxConstraints(maxWidth: 30),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text("Magnet Aufladen", style: textTheme(context).headline6),
        // ),
      ],
    );
  }
}
