import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/constants.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool drawer;
  bool? alignLeft = false;
  final bool showLogo;
  final Widget? widget;
  final Widget? dropDownButton;
  final void Function()? onBackButton;
  final void Function()? onAppBarButtonPressed;
  final List<ScreenTimeSession> screenTimes;
  final bool hasUserGivenFeedback;

  final IconData appBarButtonIcon;
  CustomAppBar({
    Key? key,
    this.height = kAppBarExtendedHeight,
    required this.title,
    this.alignLeft,
    this.drawer = false,
    this.onBackButton,
    this.widget,
    this.appBarButtonIcon = Icons.help,
    this.onAppBarButtonPressed,
    this.showLogo = false,
    this.screenTimes = const [],
    this.dropDownButton,
    this.hasUserGivenFeedback = true,
  }) : super(key: key);

  double get getHeight => height;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BaseModel>.reactive(
      viewModelBuilder: () => BaseModel(),
      // onModelReady: (model) => model.listenToScreenTime(),
      builder: (context, model, child) => PreferredSize(
        preferredSize:
            Size(screenWidth(context), height + kActiveQuestPanelMaxHeight),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              //clipBehavior: Clip.none,
              // Background
              child: Stack(
                children: [
                  if (drawer)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Badge(
                            badgeColor: kcOrange,
                            position: BadgePosition.topEnd(end: -5, top: -3),
                            showBadge: !hasUserGivenFeedback,
                            child: Icon(Icons.menu,
                                color: kcWhiteTextColor, size: 30),
                          ),
                        ),
                      ),
                    ),
                  if (dropDownButton != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: //Text("HI"),
                          Container(
                              //color: Colors.red,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: dropDownButton!),
                    ),
                  if (showLogo)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: kHorizontalPadding),
                        child: HerculesWorldLogo(sizeScale: 0.4),
                      ),
                    ),
                  Align(
                    alignment: alignLeft == true
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: FittedBox(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme(context)
                              .headline5!
                              .copyWith(color: kcWhiteTextColor),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: FittedBox(
                        child: widget,
                      ),
                    ),
                  ),
                  if (screenTimes.length > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60.0),
                        child: GestureDetector(
                          onTap: () => model.navToActiveScreenTimeView(
                              session: screenTimes[0]),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ActiveScreenTimeBadge(
                              screenTimeLeft: screenTimes.length > 1
                                  ? null
                                  : secondsToMinuteTime(
                                      model.getMinSreenTimeLeftInSeconds(
                                          sessions: screenTimes)),
                              //model.newScreenTimeLeft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (onAppBarButtonPressed != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onAppBarButtonPressed,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Icon(appBarButtonIcon,
                              color: kcWhiteTextColor, size: 35),
                        ),
                      ),
                    ),
                ],
              ),
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: kcShadowColor.withOpacity(0.15),
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0)),
              ),
              height: height,
              width: screenWidth(context),
            ),
            if (onBackButton != null && !model.hasActiveQuest)
              Container(
                height: height,
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBackButton,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            if (model.currentUserNullable != null && model.isSuperUser)
              Container(
                height: height,
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: model.openSuperUserSettingsDialog,
                  child: Text(
                    "Super User",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  //  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(height + kActiveQuestPanelMaxHeight);
}

class ActiveScreenTimeBadge extends StatefulWidget {
  final String? screenTimeLeft;

  ActiveScreenTimeBadge({Key? key, required this.screenTimeLeft})
      : super(key: key);
  @override
  _ActiveScreenTimeBadgeState createState() => _ActiveScreenTimeBadgeState();
}

class _ActiveScreenTimeBadgeState extends State<ActiveScreenTimeBadge>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = ColorTween(
            begin: kcScreenTimeBlue, end: kcScreenTimeBlue.withOpacity(0.2))
        .animate(curve);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: widget.screenTimeLeft != null ? 75 : 55,
          height: 40,
          decoration: BoxDecoration(
              //shape: BoxShape.ell,
              color: kcCultured,
              borderRadius: BorderRadius.circular(20)
              //border: Border.all(color: kcBlackHeadlineColor),
              ),
          //child: Icon(Icons.circle, size: 30, color: animation.value),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(kScreenTimeIcon2,
                    width: 20, color: animation.value),
                if (widget.screenTimeLeft != null) horizontalSpaceTiny,
                if (widget.screenTimeLeft != null)
                  InsideOutText(
                      text: widget.screenTimeLeft!,
                      style: captionStyleBold.copyWith(color: kcScreenTimeBlue))
              ],
            ),
          ),
        );
      },
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
