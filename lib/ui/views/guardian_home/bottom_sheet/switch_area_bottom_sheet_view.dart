import 'package:afkcredits/ui/views/guardian_home/bottom_sheet/switch_area_bottom_sheet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SwitchAreaBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const SwitchAreaBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SwitchAreaBottomSheetViewModel>.reactive(
      viewModelBuilder: () => SwitchAreaBottomSheetViewModel(),
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GrabberLine(),
                ),
                verticalSpaceSmall,
                Center(
                  child: InsideOutText.headingFour("Switch area",
                      align: TextAlign.center),
                ),
                verticalSpaceSmall,
                verticalSpaceTiny,
                if (model.supportedWards.length == 0) verticalSpaceMedium,
                if (model.supportedWards.length == 0)
                  Center(
                    child: InsideOutText.body(
                      "There is no child account yet",
                      align: TextAlign.center,
                    ),
                  ),
                if (model.supportedWards.length == 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: InsideOutButton.text(
                      title: "Create one",
                      onTap: () {
                        completer(
                          SheetResponse(confirmed: true),
                        );
                        model.navToCreateWardAccount();
                      },
                    ),
                  ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () async {
                            completer(
                              SheetResponse(confirmed: true),
                            );
                            await model.handleSwitchToWardEvent(
                                wardUidInput: model.supportedWards[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InsideOutText.subheading(
                                model.supportedWards[index].fullName),
                          ),
                        ),
                    separatorBuilder: (context, index) {
                      return Divider(indent: 10.0, endIndent: 10, height: 20);
                    },
                    itemCount: model.supportedWards.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
