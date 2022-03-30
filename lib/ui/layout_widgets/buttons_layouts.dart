import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';

import 'package:flutter/material.dart';

class CustomAFKButton extends StatelessWidget {
  final void Function()? onMainButtonTapped;
  final void Function()? onSecondaryButtonTapped;
  final String? mainButtonTitle;
  final String? secundaryButtonTitle;
  final MainAxisAlignment mainAxisAlignment;
  final bool busy;

  const CustomAFKButton({
    Key? key,
    this.mainButtonTitle,
    this.onMainButtonTapped,
    this.onSecondaryButtonTapped,
    this.secundaryButtonTitle,
    required this.mainAxisAlignment,
    this.busy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (secundaryButtonTitle != null)
          Expanded(
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: onSecondaryButtonTapped,
                child: Text(
                  secundaryButtonTitle!,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        horizontalSpaceMedium,
        if (mainButtonTitle != null)
          Expanded(
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: onMainButtonTapped,
                child: busy
                    ? AFKProgressIndicator(color: Colors.white)
                    : Text(
                        mainButtonTitle!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
