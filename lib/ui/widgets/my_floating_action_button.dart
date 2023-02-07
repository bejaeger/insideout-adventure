import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class AFKFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final double height;
  final double width;
  final String? title;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final bool isBusy;
  const AFKFloatingActionButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.height = 60,
      this.width = 60,
      this.backgroundColor,
      this.title,
      this.shape,
      this.isBusy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: shape != null
          ? null
          : BoxDecoration(
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 1,
              //     spreadRadius: 5,
              //     color: kShadowColor,
              //     offset: Offset(1, 1),
              //   )
              // ],
            ),
      child: FloatingActionButton(
        splashColor: kcPrimaryColorSecondary,
        elevation: 4,
        heroTag: null,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: onPressed,
        shape: shape,
        child: isBusy
            ? AFKProgressIndicator(
                alignment: Alignment.center, color: Colors.white)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  if (title != null) verticalSpaceTiny,
                  if (title != null)
                    Text(title!,
                        style: captionStyleBold.copyWith(color: Colors.white))
                ],
              ),
      ),
    );
  }
}

class AFKFloatingActionButtonRectangle extends StatelessWidget {
  final Widget icon;
  final void Function()? onPressed;
  final double height;
  final double width;
  final String? title;
  final Color? backgroundColor;
  const AFKFloatingActionButtonRectangle(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.height = 60,
      this.width = 60,
      this.backgroundColor,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      // boxShadow: [
      //   BoxShadow(
      //     blurRadius: 1,
      //     spreadRadius: 5,
      //     color: kShadowColor,
      //     offset: Offset(1, 1),
      //   )
      // ],
      child: FloatingActionButton(
        splashColor: kcPrimaryColorSecondary,
        elevation: 4,
        heroTag: null,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              if (title != null) verticalSpaceTiny,
              if (title != null)
                Text(title!,
                    style: textTheme(context)
                        .bodyText2!
                        .copyWith(color: kcWhiteTextColor, fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}
