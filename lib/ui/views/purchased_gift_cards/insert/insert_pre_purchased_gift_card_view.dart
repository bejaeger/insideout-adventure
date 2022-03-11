// ignore_for_file: must_be_immutable
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../../utils/currency/format_currency.dart';
import '../../../layout_widgets/buttons_layouts.dart';
import 'insert_pre_purchased_gift_card_view.form.dart';
import 'insert_pre_purchased_gift_card_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'amount'),
    FormTextField(name: 'category'),
    FormTextField(name: 'giftCardCode'),
  ],
)
class InsertPrePurchasedGiftCardView extends StatelessWidget
    with $InsertPrePurchasedGiftCardView {
  InsertPrePurchasedGiftCardView({Key? key}) : super(key: key);
  String? selectedGiftCardType;
  String? giftCardId;
  // String? afkCreditId;
  double? giftCardAmount;
  int? giftCardCode;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsertPrePurchasedGiftCardViewModel>.reactive(
      onModelReady: (model) {
        model.setListGiftCard();
        // listenToFormUpdated(model);
      },
      builder: (context, model, child) => model.getListOfGiftCard.isNotEmpty
          ? Scaffold(
              body: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    centerTitle: true,
                    title: Text("PrePurchased Gift Cards"),
                    floating: true,
                    expandedHeight: 80,
                    collapsedHeight: 100,
                  ),
                  InsertGiftCard(
                    model: model,
                    amountController: amountController,
                    giftCardCodeController: giftCardCodeController,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
      viewModelBuilder: () => InsertPrePurchasedGiftCardViewModel(),
    );
  }
}

class InsertGiftCard extends StatelessWidget {
  InsertPrePurchasedGiftCardViewModel? model;
  TextEditingController? amountController;
  TextEditingController? giftCardCodeController;
  InsertGiftCard(
      {required this.model,
      required this.amountController,
      this.giftCardCodeController});
  String? selectedGiftCardcategoryName;
  String? categoryId;
  //double? giftCardAmount;

  final formatCurrency = FormatCurrency();
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                // color: Colors.grey[300],
                child: Column(
                  children: [
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
                    DropdownButtonFormField<GiftCardCategory>(
                      //key: _key,
                      hint: Text('Select Category'),
                      isExpanded: true,
                      items: model!.getListOfGiftCard.map(
                        (_giftCardType) {
                          return DropdownMenuItem(
                            value: _giftCardType,
                            child: Text(
                              _giftCardType!.categoryName +
                                  " - " +
                                  formatCurrency.formatToUsd(
                                      amount: _giftCardType.amount),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (GiftCardCategory? value) {
                        selectedGiftCardcategoryName =
                            value?.categoryName.toString();

                        categoryId = value?.categoryId.toString();
                      },
                    ),
                    verticalSpaceMedium,
                    CustomAFKButton(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainButtonTitle: 'Add',
                      secundaryButtonTitle: 'Cancel',
                      onMainButtonTapped: () {
                        model!.insertPrePurchasedGiftCard(
                          categoryId: categoryId?.toString(),
                          categoryName:
                              selectedGiftCardcategoryName?.toString(),
                          giftCardCode: giftCardCodeController!.text.toString(),
                        );
                        model!.navBackToPreviousView();
                      },
                      onSecondaryButtonTapped: () {
                        model!.navBackToPreviousView();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: 1,
        ),
      ),
    );
  }
}
