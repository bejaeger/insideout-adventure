import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/gift_cards/components/gift_cards_section.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'manage_gift_card_viewmodel.dart';

class ManageGiftCardstView extends StatelessWidget {
  const ManageGiftCardstView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageGiftCardViewModel>.reactive(
      onModelReady: (model) => model.loadAllGiftCards(),
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text("Manage Gift Card"),
              floating: true,
              expandedHeight: 80,
            ),
            SliverToBoxAdapter(
              //For Prepurchased The Icon Should Be Money,
              child: SectionHeader(
                title: "Manage Gift Card ",
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: GiftCardListButton(model: model),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(title: "Available Gift Cards "),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: ListOfGiftCardsToDisplay(model: model),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => ManageGiftCardViewModel(),
    );
  }
}

// ignore: must_be_immutable
class GiftCardListButton extends StatelessWidget {
  final ManageGiftCardViewModel model;
  GiftCardListButton({required this.model});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: assetsGiftCardImages.length,
          /*  gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), */
          itemBuilder: ((BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                model.NavigateToSpecificGiftCardsView(index: index);
              },
              child: Container(
                //height: 250,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    assetsGiftCardImages[index],
                    fit: BoxFit.cover,

                    //fit: BoxFit.fill,
                  ),
                  elevation: 10,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ListOfGiftCardsToDisplay extends StatelessWidget {
  ManageGiftCardViewModel? model;
  ListOfGiftCardsToDisplay({required this.model});
  @override
  Widget build(BuildContext context) {
    return SliverList(
      /*  gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), */
      delegate: SliverChildListDelegate(
        [
          (!model!.isBusy)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceMedium,
                    ...model!
                        .getListOfGiftCardsToDisplay()
                        .map(
                          (e) => Column(
                            children: [
                              ManageGiftCardsSection(
                                giftCards: e,
                              ),
                              verticalSpaceMedium,
                            ],
                          ),
                        )
                        .toList(),
                    verticalSpaceLarge,
                  ],
                )
              : AFKProgressIndicator()
        ],
      ),
    );
  }
}
