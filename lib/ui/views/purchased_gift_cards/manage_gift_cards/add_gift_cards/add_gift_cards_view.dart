import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/enums/gift_card_type.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:uuid/uuid.dart';
import 'add_gift_cards_view.form.dart';
import 'add_gift_cards_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'amount'),
    FormTextField(name: 'description'),
    FormTextField(name: 'category'),
  ],
)
// ignore: must_be_immutable
class AddGiftCardsView extends StatelessWidget with $AddGiftCardsView {
  AddGiftCardsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddGiftCardsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text("Add Gift Cards"),
              floating: true,
              expandedHeight: 80,
            ),
            AddGiftCard(
              model: model,
              amountController: amountController,
              categoryController: categoryController,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => AddGiftCardsViewModel(),
    );
  }
}

// ignore: must_be_immutable
//TODO: Put this under Abstract Class.
class AddGiftCard extends StatelessWidget {
  var model;
  TextEditingController? amountController;
  TextEditingController? categoryController;
  AddGiftCard(
      {required this.model,
      required this.amountController,
      required this.categoryController});
  GiftCardType? selectedGiftCardType;
  String? giftCardId;
  // String? afkCreditId;
  double? giftCardAmount;
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
                labelText: 'Gift Card Amount: ',
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // focusNode: nameFocusNode,
            ),
            verticalSpaceMedium,
            TextField(
              decoration: InputDecoration(
                labelText: 'Category Name: ',
              ),
              controller: categoryController,
              keyboardType: TextInputType.text,
              // focusNode: nameFocusNode,
            ),
            verticalSpaceMedium,
            GestureDetector(
              //Get The Image Picker
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Take a Picture'),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          //Close The Dialog Box once photo was selected
                          Navigator.of(context).pop();
                          model!.selectImage('galeria');
                        },
                        child: Text('Galeria'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          //Close The Dialog Box once photo was taken
                          model!.navBackToPreviousView();
                          model!.selectImage('camera');
                        },
                        child: Text('Câmera'),
                      )
                    ],
                  );
                },
              ),
              child: Container(
                //Align the Icon Into the Center of the
                //alignment: Alignment.centerLeft,
                color: Colors.grey,
                child: Padding(
                  //padding: EdgeInsets.only(left: halfWidth),
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: model!.selectedImage != null
                        ? Image.file(
                            model!.selectedImage!,
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                //Tap to Go Fetch an Image.
                                Icons.camera_alt,
                                size: 45,
                                color: Colors.white,
                              ),
                              Text(
                                '+ Photo',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                  ),
                ),
                height: 130,
              ),
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    if (amountController!.text.isNotEmpty &&
                        categoryController!.text.isNotEmpty) {
                      var id = Uuid();
                      //selectedGiftCardType = enum.parse();
                      //  categoryController!.text;
                      giftCardAmount = double.parse(amountController!.text);
                      giftCardId = id.v1().toString().replaceAll('-', '');
                      model!.addGiftCard(
                        giftCardCategory: GiftCardCategory(
                            categoryId: giftCardId!,
                            amount: giftCardAmount!,
                            categoryName: categoryController!.text),
                      );
                    } else {
                      model.showEmptyMarkerSnackbar();
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
