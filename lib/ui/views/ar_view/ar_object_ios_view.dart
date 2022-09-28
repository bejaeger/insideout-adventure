import 'dart:async';
import 'dart:math';

import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math_64.dart';

class ARObjectIosView extends StatefulWidget {
  final bool isCoins;
  ARObjectIosView({Key? key, this.isCoins = false}) : super(key: key);

  @override
  _ARObjectIosViewState createState() => _ARObjectIosViewState();
}

class _ARObjectIosViewState extends State<ARObjectIosView> {
  final ran = Random();
  late ARKitController arkitController;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ARObjectViewModel>.reactive(
      viewModelBuilder: () => ARObjectViewModel(),
      builder: (context, model, _) => MainPage(
        onBackPressed: () => model.popArView(result: false),
        child: Stack(
          children: [
            ARKitSceneView(
              onARKitViewCreated: (ARKitController controller) =>
                  _onARKitViewCreated(
                      controller, model.handleCollectedArObjectEvent),
            ),
            Align(
              alignment: Alignment(0, 0.7),
              child: Container(
                decoration: BoxDecoration(
                    color: kcCultured, borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(8.0),
                width: screenWidth(context, percentage: 0.7),
                child: AfkCreditsText.headingThree(
                  "Tap on the credits to collect them",
                  align: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onARKitViewCreated(ARKitController arkitController,
      Future Function() handleCollectedArObjectEvent) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap = (_) => handleCollectedArObjectEvent();

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image(kAFKCreditsLogoPath),
    );
    final box =
        ARKitBox(materials: [material], width: 0.05, height: 0.8, length: 0.8);

    // random position
    double ranX =
        (1 + ran.nextDouble() * 3) * (ran.nextDouble() > 0.5 ? -1 : 1);
    double ranZ = -1.5 - ran.nextDouble() * 2;

    final node = ARKitNode(
      geometry: box,
      position: Vector3(ranX, -1, ranZ),
    );

    this.arkitController.add(node);

    timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        final rotation = node.eulerAngles;
        rotation.x += 0.01;
        node.eulerAngles = rotation;
      },
    );
  }

  // void _onNodeTapHandler(
  //     List<String> nodesList, Future Function() handleCollectedArObjectEvent) {
  // Maybe I can make some effects
  // With nodes!
  // final name = nodesList.first;
  // final color =
  //     (sphere!.materials.value!.first.diffuse as ARKitMaterialColor).color ==
  //             Colors.yellow
  //         ? Colors.blue
  //         : Colors.yellow;
  // sphere!.materials.value = [
  //   ARKitMaterial(diffuse: ARKitMaterialProperty.color(color))
  // ];
  // handleCollectedArObjectEvent();
  // showDialog<void>(
  //   context: context,
  //   builder: (BuildContext context) =>
  //       AlertDialog(content: Text('You tapped on $name')),
  // );
  // }
}
