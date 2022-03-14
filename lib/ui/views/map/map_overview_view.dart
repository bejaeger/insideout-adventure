import 'dart:io';

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'map_overview_viewmodel.dart';

class MapOverviewView extends StatelessWidget {
  const MapOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final devicePixelRatio =
    //     Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: Text("DEPRECATED"),
      ),
    );
  }
}
