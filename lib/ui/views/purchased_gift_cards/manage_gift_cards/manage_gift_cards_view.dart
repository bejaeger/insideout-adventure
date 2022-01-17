import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'manage_gift_card_viewmodel.dart';

class ManageGiftCardstView extends StatelessWidget {
  const ManageGiftCardstView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageGiftCardViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text("Manage Gift Card"),
              floating: true,
              expandedHeight: 80,
            ),
            GiftCardListButton(model: model),
          ],
        ),
      ),
      viewModelBuilder: () => ManageGiftCardViewModel(),
    );
  }
}

// ignore: must_be_immutable
class GiftCardListButton extends StatelessWidget {
  ManageGiftCardViewModel? model;
  GiftCardListButton({required this.model});
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            model!.navToAddGiftCard();

            //print('Clikced By Felix ${index.toString()}');
          },
          child: Container(
            height: 250,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(assetsGiftCardImages[index]
                  //fit: BoxFit.fill,
                  ),
              elevation: 5,
            ),
          ),
        );
      }, childCount: assetsGiftCardImages.length),
    );
  }
}
