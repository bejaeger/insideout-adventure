import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class SwitchToParentsAreaButton extends StatelessWidget {
  final void Function() onTap;
  final bool show;
  const SwitchToParentsAreaButton({
    Key? key,
    required this.onTap,
    required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.9, -0.62),
      child: FadingWidget(
        show: show,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child:
                  Image.asset(kSwitchAccountIcon, height: 25, color: kcGreen),
            ),
          ),
        ),
      ),
    );
  }
}
