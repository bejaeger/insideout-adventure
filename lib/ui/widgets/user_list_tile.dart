// User list tile e.g. for search view or friends list view

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final PublicUserInfo userInfo;
  final UserStatistics? userStats;
  final Future Function([PublicUserInfo?, UserStatistics?])? onTilePressed;
  final List<PopupMenuItem<Map<String, dynamic>>>? popUpMenuEntries;
  final void Function(Map<String, dynamic>)? onSelected;

  const UserListTile({
    Key? key,
    required this.userInfo,
    this.onTilePressed,
    this.popUpMenuEntries,
    this.onSelected,
    this.userStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTilePressed != null
          ? () async => await onTilePressed!(userInfo, userStats)
          : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: kPrimaryColor,
                child: Text(getInitialsFromName(userInfo.name),
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              title: Text(
                userInfo.name,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              subtitle: userInfo.email != null && userInfo.email != ""
                  ? Text(
                      userInfo.email!.toLowerCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              trailing: userStats == null
                  ? null
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Earned: " +
                            userStats!.afkCreditsBalance.toString() +
                            " AFK Credits"),
                        Text("Sponsoring: " +
                            formatAmount(userStats!.availableSponsoring)),
                      ],
                    )),
        ),
      ),
    );
  }
}
