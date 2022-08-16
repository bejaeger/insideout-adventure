import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function()? onSuffixIconPressed;
  final void Function()? onTap;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool showPrefixIcon;
  final String hintText;
  final bool autofocus;
  final bool readOnly;

  const SearchTextField({
    Key? key,
    this.focusNode,
    this.onChanged,
    this.hintText = "Search",
    this.autofocus = false,
    this.onSuffixIconPressed,
    this.onTap,
    this.controller,
    this.readOnly = false,
    this.suffixIcon,
    this.showPrefixIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldFocusNode = focusNode ?? FocusNode();
    return Align(
      child: Container(
        width: screenWidth(context) - kHorizontalPadding * 2,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: kcTextFieldBackground,
        ),
        child: TextField(
          readOnly: readOnly,
          controller: controller,
          onTap: onTap,
          autofocus: autofocus,
          textAlignVertical: TextAlignVertical.center,
          focusNode: textFieldFocusNode,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme(context)
                  .bodyText2!
                  .copyWith(fontSize: 16, color: Colors.grey[400]),
              contentPadding: showPrefixIcon
                  ? EdgeInsets.only(bottom: 10)
                  : EdgeInsets.only(bottom: 10, left: 10),
              border: InputBorder.none,
              prefixIcon: showPrefixIcon
                  ? Icon(Icons.search, color: Colors.grey[400])
                  : null,
              suffixIcon: onSuffixIconPressed != null
                  // workaround otherwise text field will be focused
                  ? suffixIcon != null
                      ? GestureDetector(
                          child: suffixIcon,
                          onTap: () {
                            onSuffixIconPressed!();
                          })
                      : GestureDetector(
                          child: Icon(Icons.qr_code_scanner,
                              color: Colors.grey[800]),
                          onTap: () {
                            // Unfocus all focus nodes
                            textFieldFocusNode.unfocus();
                            // // Disable text field's focus node request
                            textFieldFocusNode.canRequestFocus = false;
                            onSuffixIconPressed!();
                            //Enable the text field's focus node request after some delay
                            Future.delayed(Duration(milliseconds: 100), () {
                              textFieldFocusNode.canRequestFocus = true;
                            });
                          })
                  : null),
          style: textTheme(context)
              .bodyText2!
              .copyWith(fontSize: 16, color: Colors.grey[550]),
          cursorColor: Colors.grey[400],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
