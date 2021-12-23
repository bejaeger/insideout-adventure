import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/common_viewmodels/activated_quest_panel_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/activated_quest_panel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool drawer;
  final void Function()? onBackButton;
  CustomAppBar(
      {Key? key,
      this.height = kAppBarExtendedHeight,
      required this.title,
      this.drawer = false,
      this.onBackButton})
      : super(key: key);

  double get getHeight => height;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivatedQuestPanelViewModel>.reactive(
      viewModelBuilder: () => ActivatedQuestPanelViewModel(),
      builder: (context, model, child) => PreferredSize(
        preferredSize:
            Size(screenWidth(context), height + kActiveQuestPanelMaxHeight),
        child: Stack(
          children: <Widget>[
            ActivatedQuestPanel(heightAppBar: height),
            Container(
              alignment: Alignment.center,
              //clipBehavior: Clip.none,
              // Background
              child: Stack(children: [
                if (drawer)
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () => Scaffold.of(context).openEndDrawer(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kHorizontalPadding),
                            child: Icon(Icons.menu,
                                color: kWhiteTextColor, size: 35),
                          ))),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: FittedBox(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context)
                            .headline5!
                            .copyWith(color: kWhiteTextColor),
                      ),
                    ),
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black26,
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
                  onPressed: model.navigateBack,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            if (model.isSuperUser)
              Container(
                  height: height,
                  alignment: Alignment.topRight,
                  child: Text("Super User",
                      style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(height + kActiveQuestPanelMaxHeight);
}
