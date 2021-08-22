import 'package:afkcredits/datamodels/users/public_user_info.dart';
import 'package:afkcredits/ui/layout_widgets/search_layout.dart';
import 'package:afkcredits/ui/views/search_explorer/search_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchExplorerView extends StatelessWidget {
  SearchExplorerView({Key? key}) : super(key: key);
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchExplorerViewModel>.reactive(
      viewModelBuilder: () => SearchExplorerViewModel(),
      builder: (context, model, child) => SearchLayout(
        title: "Search Explorers",
        autofocus: model.autofocus,
        queryResult: model.userInfoList,
        query: model.queryUsers,
        focusNode: focusNode,
        isBusy: model.isBusy,
        searchItemWidget: (dynamic data) {
          return UserListTile(
              onTilePressed: (PublicUserInfo userInfo) async {
                focusNode.unfocus();
                await model.selectUserAndProceed(userInfo);
              },
              userInfo: data);
        },
      ),
    );
  }
}
