import 'package:afkcredits/ui/layout_widgets/layout_settings.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

// not used atm
class CustomSliverAppBarSmall extends StatelessWidget {
  final String title;
  final void Function()? onRightIconPressed;
  final void Function()? onSecondRightIconPressed;
  final Widget? rightIcon;
  final Widget? secondRightIcon;
  final bool pinned;
  final PreferredSize? bottom;

  const CustomSliverAppBarSmall(
      {Key? key,
      required this.title,
      this.onRightIconPressed,
      this.rightIcon,
      this.pinned = true,
      this.bottom,
      this.onSecondRightIconPressed,
      this.secondRightIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: textTheme(context).headline3!.copyWith(fontSize: 22)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onRightIconPressed != null)
                    GestureDetector(
                      onTap: onRightIconPressed,
                      child: rightIcon ??
                          Icon(
                            Icons.person,
                            color: kcWhiteTextColor,
                            size: 25,
                          ),
                    ),
                  if (onSecondRightIconPressed != null) SizedBox(width: 20.0),
                  if (onSecondRightIconPressed != null)
                    GestureDetector(
                      onTap: onSecondRightIconPressed,
                      child: secondRightIcon ??
                          Icon(
                            Icons.person,
                            color: kcWhiteTextColor,
                            size: 25,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
      titleSpacing: 20,
      expandedHeight: LayoutSettings.minAppBarHeight * 1,
      collapsedHeight: LayoutSettings.minAppBarHeight,
      backgroundColor: kcPrimaryColor, //Colors.white,
      elevation: 2.0,
      toolbarHeight: LayoutSettings.minAppBarHeight,
      pinned: pinned,
      bottom: bottom,
    );
  }
}
