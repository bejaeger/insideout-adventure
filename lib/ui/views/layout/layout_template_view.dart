import 'package:afkcredits/ui/views/layout/afk_bottom_navigation_bar.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LayoutTemplateView extends StatelessWidget {
  final Widget childView;
  const LayoutTemplateView({Key? key, required this.childView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LayoutTemplateViewModel>.reactive(
      viewModelBuilder: () => LayoutTemplateViewModel(),
      onModelReady: (model) => model.listenToLayoutSettings(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Expanded(
                child: SafeArea(child: childView),
              ),
              AFKBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }
}
