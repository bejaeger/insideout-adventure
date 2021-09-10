import 'package:afkcredits/ui/layout_widgets/layout_settings.dart';
import 'package:flutter/material.dart';

// Wrap views with this widget to constrain the width of the
// app to a maximum (defined by LayoutSettings.maxAppWith) so that it
// looks reasonable in a desktop browser.
// Does not have an effect on mobile....

class ConstrainedWidthLayout extends StatelessWidget {
  final Widget child;

  const ConstrainedWidthLayout({Key? key, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: LayoutSettings.maxAppWidth),
          child: child,
        ),
      ),
    );
  }
}

class ConstrainedWidthWithScaffoldLayout extends StatelessWidget {
  final Widget child;
  final bool? resizeToAvoidBottomInset;

  const ConstrainedWidthWithScaffoldLayout(
      {Key? key, required this.child, this.resizeToAvoidBottomInset})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: LayoutSettings.maxAppWidth),
          child: Scaffold(
              resizeToAvoidBottomInset: resizeToAvoidBottomInset, body: child),
        ),
      ),
    );
  }
}
