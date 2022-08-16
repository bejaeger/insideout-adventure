import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AfkCreditsInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final String? errorText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? trailingTapped;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  AfkCreditsInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.obscureText = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

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
        controller: controller,
        style: const TextStyle(height: 1),
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
