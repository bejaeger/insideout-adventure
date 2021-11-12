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
  CustomAppBar({Key? key, this.height = 80, required this.title})
      : super(key: key);

  double get getHeight => height;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivatedQuestPanelViewModel>.reactive(
      viewModelBuilder: () => ActivatedQuestPanelViewModel(),
      builder: (context, model, child) => PreferredSize(
        preferredSize:
            Size(screenWidth(context), height + kAppBarExtendedHeight),
        child: Stack(
          children: <Widget>[
            ActivatedQuestPanel(height: height),
            Container(
              alignment: Alignment.center,
              //clipBehavior: Clip.none,
              // Background
              child: Text(title,
                  style: textTheme(context)
                      .headline5!
                      .copyWith(color: Colors.grey[50])),
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
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0)),
              ),
              height: height,
              width: screenWidth(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + kAppBarExtendedHeight);
}
