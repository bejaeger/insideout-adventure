import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class MapLoadingOverlay extends StatelessWidget {
  final bool show;
  const MapLoadingOverlay({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: AfkCreditsText.headingThree("Loading..."),
      ),
    );
  }
}
