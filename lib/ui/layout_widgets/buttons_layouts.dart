import 'package:afkcredits/utils/ui_helpers.dart';
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
        Expanded(
          child: SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: onMainButtonTapped,
              child: busy
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    )
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
        horizontalSpaceMedium,
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
      ],
    );
  }
}
