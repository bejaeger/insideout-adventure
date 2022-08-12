import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:afkcredits_ui/src/shared/styles.dart';
import 'package:flutter/material.dart';

// const Color DarkTurquoise = Color(0xFF00827e);

class AfkCreditsButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final bool enabled;
  final bool textButton;
  final Widget? leading;
  final Color? color;

  const AfkCreditsButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.enabled = true,
    this.busy = false,
    this.textButton = false,
    this.onTap,
    this.leading,
    this.color,
  })  : outline = false,
        super(key: key);

  const AfkCreditsButton.outline({
    required this.title,
    this.onTap,
    this.leading,
    this.color,
    this.enabled = false,
  })  : disabled = false,
        busy = false,
        textButton = false,
        outline = true;

  const AfkCreditsButton.text({
    required this.title,
    this.onTap,
    this.leading,
    this.color,
    this.enabled = false,
  })  : disabled = false,
        busy = false,
        outline = true,
        textButton = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 48,
        alignment: Alignment.center,
        decoration: textButton
            ? null
            : (!outline || enabled)
                ? BoxDecoration(
                    color: !disabled ? color ?? kcPrimaryColor : kcMediumGrey,
                    borderRadius: BorderRadius.circular(20),
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color ?? kcPrimaryColor,
                      width: 2,
                    )),
        child: !busy
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  if (leading != null) const SizedBox(width: 5),
                  Text(
                    title,
                    style: bodyStyle.copyWith(
                      fontWeight: (!outline || enabled || textButton)
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: (!outline || enabled)
                          ? Colors.white
                          : color ?? kcPrimaryColor,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
      ),
    );
  }
}
