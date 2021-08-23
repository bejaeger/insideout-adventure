import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/widgets/search_test_field.dart';
import 'package:afkcredits/utils/debouncer.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class SearchLayout extends StatelessWidget {
  final bool autofocus;

  final Future<void> Function(String) query;
  final List<dynamic> queryResult;

  final Widget Function(dynamic) searchItemWidget;
  final String title;

  final void Function()? onSuffixIconPressed;
  final bool isBusy;
  final Widget? suffixIcon;

  final Debouncer _debouncer = Debouncer(milliseconds: 200);

  final FocusNode? focusNode;

  SearchLayout(
      {Key? key,
      this.autofocus = false,
      this.onSuffixIconPressed,
      this.suffixIcon,
      required this.queryResult,
      required this.title,
      required this.query,
      required this.searchItemWidget,
      this.focusNode,
      this.isBusy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode actualFocusNode = focusNode ?? FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        children: [
          verticalSpaceSmall,
          SearchTextField(
            focusNode: actualFocusNode,
            autofocus: autofocus,
            onSuffixIconPressed: onSuffixIconPressed != null
                ? () async {
                    actualFocusNode.unfocus();
                    onSuffixIconPressed!();
                  }
                : null,
            onChanged: (String pattern) async {
              // await model.queryUsers(pattern);
              _debouncer.run(() async {
                await query(pattern);
              });
            },
          ),
          verticalSpaceSmall,
          isBusy
              ? CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: queryResult.length,
                  itemBuilder: (context, index) {
                    final data = queryResult[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kHorizontalPadding * 0.5),
                      child: searchItemWidget(data),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
