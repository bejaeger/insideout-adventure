import 'package:afkcredits/ui/views/common_viewmodels/main_page_viewmodel.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainPage extends StatelessWidget {
  final void Function()? onBackPressed;
  final bool showBackButton;
  final Widget child;
  final bool? resizeToAvoidBottomInset;
  const MainPage(
      {Key? key,
      this.onBackPressed,
      required this.child,
      this.showBackButton = true,
      this.resizeToAvoidBottomInset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: MainStack(
          child: child,
          onBackPressed: onBackPressed,
          showBackButton: showBackButton,
        ),
      ),
    );
  }
}

class MainStack extends StatelessWidget {
  final Widget child;
  final void Function()? onBackPressed;
  final bool showBackButton;

  const MainStack({
    Key? key,
    required this.child,
    this.onBackPressed,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainPageViewModel>.reactive(
      viewModelBuilder: () => MainPageViewModel(),
      builder: (context, model, _) => Stack(
        children: [
          child,
          if (showBackButton)
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 20),
              child: RoundCloseButton(
                  onTap:
                      onBackPressed != null ? onBackPressed! : model.popView),
            ),
        ],
      ),
    );
  }
}
