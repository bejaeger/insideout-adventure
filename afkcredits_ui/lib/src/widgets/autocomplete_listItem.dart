import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class AutoCompleteListItem extends StatelessWidget {
  final String state, city;
  final Function onTap;

  const AutoCompleteListItem(
      {Key? key, required this.state, required this.city, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.near_me,
            color: kcMediumGreyColor,
          ),
          onTap: () => onTap(),
          title: AfkCreditsText.subheading(city),
          subtitle: AfkCreditsText.caption(state),
        ),
        const Divider(
          indent: 50,
        )
      ],
    );
  }
}
