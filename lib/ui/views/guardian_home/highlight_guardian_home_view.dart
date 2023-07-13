import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/guardian_home/guardian_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

class HighlightGuardianHomeView extends StatefulWidget {
  final ScreenTimeSession? screenTimeSession;
  final bool highlightBubbles;
  const HighlightGuardianHomeView(
      {Key? key, this.screenTimeSession, this.highlightBubbles = false})
      : super(key: key);

  @override
  State<HighlightGuardianHomeView> createState() =>
      _HighlightGuardianHomeViewState();
}

class _HighlightGuardianHomeViewState extends State<HighlightGuardianHomeView> {
  bool allowShowDialog = false;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onComplete: (index, key) {
        if (index == 5) {
          setState(() {
            allowShowDialog = true;
          });
        }
      },
      blurValue: 1,
      builder: Builder(
        builder: (context) => GuardianHomeView(
          highlightBubbles: widget.highlightBubbles,
          screenTimeSession: widget.screenTimeSession,
          allowShowDialog: allowShowDialog,
        ),
      ),
    );
  }
}
