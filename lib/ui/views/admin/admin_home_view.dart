import 'package:afkcredits/ui/views/admin/admin_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdminHomeViewModel>.reactive(
      viewModelBuilder: () => AdminHomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Admin Home View")),
      ),
    );
  }
}
