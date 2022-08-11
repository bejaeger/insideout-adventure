import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CommonDrawerView extends StatelessWidget {
  final List<Widget> children;
  const CommonDrawerView({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommonDrawerViewModel>.reactive(
      viewModelBuilder: () => CommonDrawerViewModel(),
      builder: (context, model, child) => SizedBox(
        width: screenWidth(context, percentage: 0.7),
        child: Drawer(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 25, bottom: 25, right: 25, left: 70),
                                child: AfkCreditsText.headingTwo("MENU")),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: GestureDetector(
                            onTap: model.popView,
                            child: Icon(Icons.arrow_back,
                                color: Colors.black, size: 35),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Column(
                    children: children,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
