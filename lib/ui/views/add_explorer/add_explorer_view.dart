import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/verify_network_connection/verify_network_connection.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked/stacked_annotations.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_view.form.dart';

import 'validators.dart';

@FormView(
  fields: [
    FormTextField(name: 'name', validator: FormValidators.nameValidator),
    FormTextField(
        name: 'password', validator: FormValidators.passwordValidator),
  ],
  autoTextFieldValidation: false,
)
class AddExplorerView extends StatelessWidget with $AddExplorerView {
  AddExplorerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddExplorerViewModel>.reactive(
      viewModelBuilder: () => AddExplorerViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Create Child Account"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: ListView(
            children: [
              Column(
                children: [
                  verticalSpaceLarge,
                  AfkCreditsInputField(
                    placeholder: 'Name',
                    controller: nameController,
                    autofocus: true,
                  ),
                  verticalSpaceMedium,
                  AfkCreditsInputField(
                    placeholder: 'Password',
                    obscureText: (model.isPwShown) ? false : true,
                    controller: passwordController,
                    trailing: IconButton(
                      onPressed: () {
                        model.setIsPwShown(!model.isPwShown);
                      },
                      icon: (model.isPwShown)
                          ? Icon(Icons.visibility, color: kcPrimaryColor)
                          : Icon(Icons.visibility_off, color: kcPrimaryColor),
                    ),
                  ),
                ],
              ),
              verticalSpaceLarge,
              AfkCreditsButton(
                  busy: model.isBusy,
                  // onPressed: model.navigateToExplorerHomeView,
                  onTap: model.addExplorer,
                  //child: Text("Go to explorer home/map")),
                  title: "Create Account"),
            ],
          ),
        ),
      ),
    );
  }
}
