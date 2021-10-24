import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/ps/ps.dart';
import 'package:afkcredits/ui/widgets/steam/steam.dart';
import 'package:afkcredits/ui/widgets/xbox/xbox.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class GiftCardView extends StatelessWidget {
  const GiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gift Card List',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 90.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                steamWidget(context),
                verticalSpaceMedium,
                psWidget(context),
                verticalSpaceMedium,
                xboxWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
