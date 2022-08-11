import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool drawer;
  bool? alignLeft = false;
  final bool showRedLiveButton;
  final Widget? widget;
  final void Function()? onBackButton;
  final void Function()? onAppBarButtonPressed;

  final IconData appBarButtonIcon;
  CustomAppBar(
      {Key? key,
      this.height = kAppBarExtendedHeight,
      required this.title,
      this.alignLeft,
      this.drawer = false,
      this.onBackButton,
      this.widget,
      this.appBarButtonIcon = Icons.help,
      this.showRedLiveButton = false,
      this.onAppBarButtonPressed})
      : super(key: key);

  double get getHeight => height;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BaseModel>.reactive(
      viewModelBuilder: () => BaseModel(),
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
                          child: Icon(Icons.menu,
                              color: kcWhiteTextColor, size: 30),
                        ),
                      ),
                    ),
                  Align(
                    alignment: alignLeft == true
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
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
                  if (showRedLiveButton)
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        opacity: model.hasActiveQuest ? 1 : 0,
                        duration: Duration(seconds: 1),
                        child: GestureDetector(
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: BlinkAnimation(),
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
                  // mainAxisSize: MainAxisSize.min,
                  //children: [
                  // IconButton(
                  //     visualDensity: VisualDensity.compact,
                  //     padding: const EdgeInsets.all(0),
                  //     onPressed: model.openSuperUserSettingsDialog,
                  //     icon: Icon(Icons.settings,
                  //         color: model.listenedToNewPosition
                  //             ? Colors.orange
                  //             : Colors.white,
                  //         size: 16)),
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

class BlinkAnimation extends StatefulWidget {
  @override
  _BlinkAnimationState createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation>
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
    animation =
        ColorTween(begin: Colors.red, end: Colors.red.shade900).animate(curve);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kcBlackHeadlineColor)),
            child: Icon(Icons.circle, size: 30, color: animation.value));
      },
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
