import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/set_pin/set_pin_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:afkcredits/ui/views/set_pin/set_pin_view.form.dart';

// Might wanna switch to this package!
// https://pub.dev/packages/pin_code_fields

@FormView(fields: [
  FormTextField(name: 'number1'),
  FormTextField(name: 'number2'),
  FormTextField(name: 'number3'),
  FormTextField(name: 'number4'),
])
class SetPinView extends StatelessWidget with $SetPinView {
  SetPinView({Key? key}) : super(key: key);

  List<String> _pin = ["", "", "", ""];
  int numberFields = 4;
  Widget textFields = Container();

  // settings
  bool showFieldAsBox = true;
  double fieldWidth = 40.0;
  double fontSize = 20.0;
  bool isTextObscure = false;
  Color cursorColor =
      kcPrimaryColorSecondary; // Adding a Material Color so that if the user want black, it get accepted too

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetPinViewModel>.reactive(
      viewModelBuilder: () => SetPinViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Enter Passcode"),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding, vertical: 50),
            child: Column(
              children: [
                IgnorePointer(child: generateTextFields(context, model)),
                verticalSpaceMedium,
                AfkCreditsButton.text(
                  leading: Icon(Icons.clear, color: kcPrimaryColor),
                  title: "Clear",
                  onTap: () => clearTextFields(),
                )
              ],
            )),
      ),
    );
  }

  List<TextEditingController> getControllers() {
    return [
      number1Controller,
      number2Controller,
      number3Controller,
      number4Controller
    ];
  }

  List<FocusNode> getFocusNodes() {
    return [
      number1FocusNode,
      number2FocusNode,
      number3FocusNode,
      number4FocusNode
    ];
  }

  Widget generateTextFields(BuildContext context, dynamic model) {
    List<Widget> textFields = List.generate(numberFields, (int i) {
      return buildTextField(i, context, model, i == 0);
    });
    number1FocusNode.requestFocus();
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  Widget buildTextField(int i, BuildContext context, dynamic model,
      [bool autofocus = false]) {
    final String lastDigit = getControllers()[i].text;

    return Container(
      width: 50,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: getControllers()[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: cursorColor,
        maxLength: 1,
        autofocus: autofocus,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        focusNode: getFocusNodes()[i],
        obscureText: isTextObscure,
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: showFieldAsBox
                ? OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: kcPrimaryColor))
                : null,
            focusedBorder: showFieldAsBox
                ? OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: kcPrimaryColor))
                : null),
        onChanged: (String str) async {
          print("current i = $i");
          _pin[i] = str;
          if (i + 1 != numberFields) {
            getFocusNodes()[i].unfocus();
            if (_pin[i] == '') {
              if (i - 1 >= 0) {
                print("jumping one down to ${i - 1}");
                getFocusNodes()[i - 1].requestFocus();
              } //FocusScope.of(context).requestFocus(getFocusNodes()[i - 1]);
            } else {
              print("jumping one up to ${i + 1}");
              getFocusNodes()[i + 1].requestFocus();
              // FocusScope.of(context).requestFocus(getFocusNodes()[i + 1]);
            }
          } else {
            getFocusNodes()[i].unfocus();
            if (_pin[i] == '') {
              if (i - 1 >= 0) {
                getFocusNodes()[i - 1].requestFocus();
              } // FocusScope.of(context).requestFocus(getFocusNodes()[i - 1]);
            }
          }
          if (_pin.every((String digit) => digit != '')) {
            //final res = await
            model.onSubmit(_pin.join());
            //if (res == true) {
            clearTextFields();
            //}
          }
        },
      ),
    );
  }

  void clearTextFields() {
    getControllers().forEach(
        (TextEditingController tEditController) => tEditController.clear());
    _pin = ["", "", "", ""];
    number1FocusNode.requestFocus();
  }
}
