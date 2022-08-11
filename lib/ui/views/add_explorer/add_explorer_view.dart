import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/verify_network_connection/verify_network_connection.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked/stacked_annotations.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'name'),
  FormTextField(name: 'password'),
])
class AddExplorerView extends StatelessWidget with $AddExplorerView {
  AddExplorerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddExplorerViewModel>.reactive(
      viewModelBuilder: () => AddExplorerViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => VerifyNetworkConnection(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add Explorer"),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(kHorizontalPadding),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Explorer name'),
                      controller: nameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              model.setIsPwShown(!model.isPwShown);
                            },
                            icon: (model.isPwShown)
                                ? Icon(Icons.visibility, color: kcPrimaryColor)
                                : Icon(Icons.visibility_off,
                                    color: kcPrimaryColor),
                          )),
                      obscureText: (model.isPwShown) ? false : true,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              model.isBusy
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      // onPressed: model.navigateToExplorerHomeView,
                      onPressed: model.addExplorer,
                      //child: Text("Go to explorer home/map")),
                      child: Text("Add")),
            ],
          ),
        ),
      ),
    );
  }
}
