import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// See example 6 here: https://pub.dev/packages/dropdown_button2#6-dropdownbutton2-as-popup-menu-button-using-custombutton-parameter
// Currently only supports two items!

class CustomDropDownMenu extends StatefulWidget {
  final Widget icon1;
  final String text1;
  final void Function() onTap1;
  final Widget? icon2;
  final String? text2;
  final void Function()? onTap2;
  const CustomDropDownMenu(
      {Key? key,
      required this.onTap1,
      required this.icon1,
      required this.text1,
      this.icon2,
      this.text2,
      this.onTap2})
      : super(key: key);

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  List<MenuItem> getItems() {
    List<MenuItem> list = [
      MenuItem(text: widget.text1, icon: widget.icon1, onTap: widget.onTap1)
    ];
    if (widget.onTap2 != null && widget.icon2 != null && widget.text2 != null)
      list = list +
          [
            MenuItem(
                text: widget.text2!, icon: widget.icon2!, onTap: widget.onTap2!)
          ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<MenuItem>(
        customButton: const Icon(
          Icons.more_vert, size: 26, color: kcWhiteTextColor,
          //color: Colors.red,
        ),
        dropdownElevation: 4,
        offset: const Offset(0, 0),
        customItemsHeights: List.filled(getItems().length, 48),
        items: [
          ...getItems().map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
              onTap: item.onTap,
            ),
          ),
        ],
        onChanged: (_) {
          return;
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final Widget icon;
  final void Function() onTap;

  const MenuItem({
    required this.text,
    required this.icon,
    required this.onTap,
  });
}

class MenuItems {
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        item.icon,
        const SizedBox(
          width: 10,
        ),
        AfkCreditsText.body(
          item.text,
        ),
      ],
    );
  }
}
