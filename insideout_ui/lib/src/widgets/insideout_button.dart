import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class InsideOutButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final bool enabled;
  final bool textButton;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final double? height;
  final Border? border;
  final double? width;
  final List<BoxShadow>? boxShadow;

  const InsideOutButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.enabled = true,
    this.busy = false,
    this.textButton = false,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    this.height,
    this.border,
    this.boxShadow,
    this.width,
  })  : outline = false,
        super(key: key);

  const InsideOutButton.outline({
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    this.height,
    this.border,
    this.enabled = false,
    this.width,
  })  : disabled = false,
        boxShadow = null,
        busy = false,
        textButton = false,
        outline = true;

  const InsideOutButton.text({
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    this.height,
    this.width,
    this.enabled = false,
  })  : disabled = false,
        busy = false,
        boxShadow = null,
        outline = true,
        textButton = true,
        border = null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height ?? 48,
        alignment: Alignment.center,
        decoration: textButton
            ? null
            : (!outline || enabled)
                ? BoxDecoration(
                    color: !disabled ? color ?? kcPrimaryColor : kcMediumGrey,
                    borderRadius: BorderRadius.circular(20),
                    border: border,
                    boxShadow: boxShadow)
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: border ??
                        Border.all(
                          color: color ?? kcPrimaryColor,
                          width: 2,
                        ),
                  ),
        child: !busy
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  if (leading != null && title != "") horizontalSpaceTiny,
                  if (leading != null && title != "") const SizedBox(width: 5),
                  if (title != "")
                    Text(
                      title,
                      style: bodyStyleSofia.copyWith(
                        fontWeight: (!outline || enabled || textButton)
                            ? FontWeight.bold
                            : FontWeight.w400,
                        color: (!outline || enabled)
                            ? Colors.white
                            : color ?? kcPrimaryColor,
                      ),
                    ),
                  if (trailing != null && title != "") horizontalSpaceTiny,
                  if (trailing != null && title != "") const SizedBox(width: 5),
                  if (trailing != null) trailing!,
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
