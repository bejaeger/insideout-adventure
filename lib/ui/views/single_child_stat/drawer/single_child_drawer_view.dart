import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_view.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_viewmodel.dart';
import 'package:afkcredits/ui/views/single_child_stat/drawer/single_child_drawer_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleChildDrawerView extends StatelessWidget {
  final User? explorer;
  const SingleChildDrawerView({Key? key, required this.explorer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleChildDrawerViewModel>.reactive(
      viewModelBuilder: () => SingleChildDrawerViewModel(explorer: explorer),
      builder: (context, model, child) => CommonDrawerView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: AfkCreditsButton(
                    title: "Remove Child",
                    onTap: model.removeChildFromParentAccount),
              ),
            ],
          ),
        ),
        verticalSpaceMedium,
      ]),
    );
  }
}
