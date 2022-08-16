import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AfkCreditsDropdownFormField<T> extends StatelessWidget {
  final bool isLoading;
  final T? value;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final List<DropdownMenuItem<T>> items;
  final void Function()? trailingTapped;
  final void Function(T?)? onChanged;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  AfkCreditsDropdownFormField({
    Key? key,
    required this.items,
    this.value,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.errorText,
    this.inputFormatters,
    this.isLoading = true,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      /// Overriding the default blue color.
      ///
      /// We can also avoid this by changing the [primarySwatch] in MaterialApp
      data: ThemeData(primaryColor: kcPrimaryColor),
      child: DropdownButtonFormField<T>(
        //key: _key,
        decoration: InputDecoration(
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
        value: value,
        hint: Text(placeholder),
        isExpanded: true,
        items: items,
        // items: CreateQuestType.values.map(
        //   (_questType) {
        //     return DropdownMenuItem(
        //       value: _questType == CreateQuestType.TreasureLocationSearch
        //           ? QuestType.TreasureLocationSearch
        //           : _questType == CreateQuestType.GPSAreaHike
        //               ? QuestType.GPSAreaHike
        //               : QuestType.GPSAreaHunt,
        //       child: model.isLoading == false
        //           ? Text(
        //               _questType.toString().split('.').elementAt(1),
        //             )
        //           : Text(
        //               "Select Quest Type",
        //             ),
        //     );
        //   },
        // ).toList(),
        onChanged: onChanged,
        // (QuestType? questType) {
        //   questTypeValue = questType;
        //   model.setQuestType(questType: questType!);
        // },
      ),
    );
  }
}
