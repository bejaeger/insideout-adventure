import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_view.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final bool show;
  final num balance;
  final void Function()? onPressed;
  final void Function()? onCreditsPressed;
  const MainHeader(
      {Key? key,
      this.onPressed,
      required this.show,
      required this.balance,
      this.onCreditsPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //log.wtf("Rebuilding MainHeader");
    return IgnorePointer(
      ignoring: !show,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: 70,
          //color: Colors.blue.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarView(percentage: 0.4, level: 3, onPressed: onPressed),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 14),
                child: AFKCreditsDisplay(
                    balance: balance, onPressed: onCreditsPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
