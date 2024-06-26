import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insideout_ui/insideout_ui.dart';

class InsideOutInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final String? errorText;
  final TextInputType keyboardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? trailingTapped;
  final TextStyle? style;
  final int maxLines;
  final FocusNode? focusNode;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  InsideOutInputField(
      {Key? key,
      required this.controller,
      this.placeholder = '',
      this.leading,
      this.trailing,
      this.trailingTapped,
      this.obscureText = false,
      this.errorText,
      this.keyboardType = TextInputType.text,
      this.inputFormatters,
      this.autofocus = false,
      this.maxLines = 1,
      this.style,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      /// Overriding the default blue color.
      ///
      /// We can also avoid this by changing the [primarySwatch] in MaterialApp
      data: Theme.of(context).copyWith(
        primaryColor: kcPrimaryColor,
      ),
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        style: style ?? const TextStyle(height: 1),
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: placeholder,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          filled: true,
          fillColor: kcVeryLightGrey,
          prefixIcon: leading,
          suffixIcon: trailing != null
              ? GestureDetector(
                  onTap: trailingTapped,
                  child: trailing,
                )
              : null,
          errorText: errorText,
          errorMaxLines: 2,
          border: circularBorder.copyWith(
            borderSide: const BorderSide(color: kcLightGrey),
          ),
          errorBorder: circularBorder.copyWith(
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: circularBorder.copyWith(
            borderSide: const BorderSide(color: kcPrimaryColor),
          ),
          enabledBorder: circularBorder.copyWith(
            borderSide: const BorderSide(color: kcLightGrey),
          ),
        ),
      ),
    );
  }
}
