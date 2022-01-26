import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/enums/gift_card_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:uuid/uuid.dart';
import 'insert_pre_purchased_gift_card_view.form.dart';
import 'insert_pre_purchased_gift_card_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'amount'),
    FormTextField(name: 'category'),
    FormTextField(name: 'giftCardCode'),
  ],
)
//TODO: Make This Class Abstract
class InsertPrePurchasedGiftCardView extends StatelessWidget
    with $InsertPrePurchasedGiftCardView {
  InsertPrePurchasedGiftCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsertPrePurchasedGiftCardViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text("Insert PrePurchased Gift Cards"),
              floating: true,
              expandedHeight: 80,
            ),
            InsertGiftCard(
              model: model,
              amountController: amountController,
              giftCardCodeController: giftCardCodeController,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => InsertPrePurchasedGiftCardViewModel(),
    );
  }
}

//TODO: Put this under Abstract Class.
// ignore: must_be_immutable
class InsertGiftCard extends StatelessWidget {
  InsertPrePurchasedGiftCardViewModel? model;
  TextEditingController? amountController;
  TextEditingController? giftCardCodeController;
  InsertGiftCard(
      {required this.model,
      required this.amountController,
      this.giftCardCodeController});
  GiftCardType? selectedGiftCardType;
  String? giftCardId;
  // String? afkCreditId;
  double? giftCardAmount;
  int? giftCardCode;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            verticalSpaceLarge,
            TextField(
              decoration: InputDecoration(
                labelText: 'Gift Card Code: ',
              ),
              maxLength: 16,
              controller: giftCardCodeController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // focusNode: nameFocusNode,
            ),
            verticalSpaceMedium,
            DropdownButtonFormField<GiftCardType>(
              //key: _key,
              hint: Text('Select Category'),
              isExpanded: true,
              items: GiftCardType.values.map((_giftCardType) {
                return DropdownMenuItem(
                  value: _giftCardType,
                  child: Text(
                    _giftCardType.toString().split('.').elementAt(1),
                  ),
                );
              }).toList(),
              onChanged: (GiftCardType? value) {
                selectedGiftCardType = value;
              },
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    if (giftCardCodeController!.text.isNotEmpty &&
                        giftCardCodeController!.text.length == 16) {
                      var id = Uuid();

                      giftCardCode = int.parse(giftCardCodeController!.text);
                      giftCardId = id.v1().toString().replaceAll('-', '');
                      model!.insertPrePurchasedGiftCard(
                        prePurchasedGiftCard: PrePurchasedGiftCard(
                            categoryId: giftCardId!,
                            giftCardCode: giftCardCode!,
                            categoryName: selectedGiftCardType!),
                      );
                    } else {
                      model!.emptyTextFields();
                    }
                  },
                  icon: const Icon(Icons.add_box),
                  label: const Text(
                    "add  ",
                  ),
                ),
                horizontalSpaceSmall,
                ElevatedButton.icon(
                  onPressed: () {
                    model!.navBackToPreviousView();
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text(
                    "Cancel",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
