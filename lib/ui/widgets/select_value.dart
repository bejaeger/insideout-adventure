import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class SelectValue extends StatelessWidget {
  final String userPrompt;
  final Widget inputField;
  final Widget equivalentValueWidget;
  final String? validationMessage;
  final Widget ctaButton;
  const SelectValue(
      {Key? key,
      required this.userPrompt,
      required this.inputField,
      required this.equivalentValueWidget,
      this.validationMessage,
      required this.ctaButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceMedium,
          InsideOutText.subheading(userPrompt),
          verticalSpaceMedium,
          Row(
            children: [
              Container(
                  width: screenWidth(context, percentage: 0.35),
                  child: inputField),
              //Container(color: Colors.red),
              horizontalSpaceSmall,
              Icon(Icons.arrow_right_alt, size: 26),
              horizontalSpaceSmall,
              Expanded(child: equivalentValueWidget)
            ],
          ),
          validationMessage == null ? verticalSpaceMedium : verticalSpaceSmall,
          if (validationMessage != null) InsideOutText.warn(validationMessage!),
          if (validationMessage != null) verticalSpaceSmall,
          ctaButton,
        ],
      ),
    );
  }
}
