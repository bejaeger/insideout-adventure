import 'package:afkcredits/ui/views/parent_home/bottom_sheet/switch_area_bottom_sheet_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
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
          // color: Colors.grey[100],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
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
                  child: AfkCreditsText.headingFour("Switch area",
                      align: TextAlign.center),
                ),
                verticalSpaceSmall,
                verticalSpaceTiny,
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () async {
                            completer(
                              SheetResponse(confirmed: true),
                            );
                            await model.handleSwitchToExplorerEvent(
                                explorerUidInput:
                                    model.supportedExplorers[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AfkCreditsText.subheading(
                                model.supportedExplorers[index].fullName),
                          ),
                        ),
                    separatorBuilder: (context, index) {
                      return Divider(indent: 10.0, endIndent: 10, height: 20);
                    },
                    itemCount: model.supportedExplorers.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
