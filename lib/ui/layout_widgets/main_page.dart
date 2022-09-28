import 'package:afkcredits/ui/views/common_viewmodels/main_page_viewmodel.dart';
import 'package:afkcredits/ui/widgets/round_close_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainPage extends StatelessWidget {
  final void Function()? onBackPressed;
  final bool showBackButton;
  final Color? backButtonColor;
  final Widget child;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const MainPage(
      {Key? key,
      this.onBackPressed,
      required this.child,
      this.showBackButton = true,
      this.resizeToAvoidBottomInset,
      this.backButtonColor,
      this.floatingActionButton,
      this.floatingActionButtonLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        body: Container(
          child: MainStack(
            child: child,
            onBackPressed: onBackPressed,
            showBackButton: showBackButton,
            backButtonColor: backButtonColor,
          ),
        ),
      ),
    );
  }
}

class MainStack extends StatelessWidget {
  final Widget child;
  final void Function()? onBackPressed;
  final bool showBackButton;
  final Color? backButtonColor;
  const MainStack({
    Key? key,
    required this.child,
    this.onBackPressed,
    this.showBackButton = true,
    this.backButtonColor,
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
              padding: const EdgeInsets.only(
                  bottom:
                      12), // another padding is added to increase tap size of button
              child: RoundCloseButton(
                  color: backButtonColor,
                  onTap:
                      onBackPressed != null ? onBackPressed! : model.popView),
            ),
        ],
      ),
    );
  }
}
