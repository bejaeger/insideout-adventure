import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
      alignment: Alignment(0.9, -0.7),
      child: FadingWidget(
        show: show,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: kcCultured,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: kcShadowColor,
                    offset: Offset(1, 1),
                    blurRadius: 0.5,
                    spreadRadius: 0.2,
                  )
                ]),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            width: 50,
            height: 95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AfkCreditsText.vertical("P"),
                      AfkCreditsText.vertical("A"),
                      AfkCreditsText.vertical("R"),
                      AfkCreditsText.vertical("E"),
                      AfkCreditsText.vertical("N"),
                      AfkCreditsText.vertical("T"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      AfkCreditsText.vertical("A"),
                      AfkCreditsText.vertical("R"),
                      AfkCreditsText.vertical("E"),
                      AfkCreditsText.vertical("A"),
                      Text(
                        "\u279A",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kcOrange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}