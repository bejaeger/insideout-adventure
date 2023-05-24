import 'dart:async';
import 'dart:math';

import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_viewmodel.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
        backButtonColor: kcCultured,
        child: Stack(
          children: [
            ARKitSceneView(
              onARKitViewCreated: (ARKitController controller) =>
                  _onARKitViewCreated(
                      controller, model.handleCollectedArObjectEvent),
              enableTapRecognizer: true,
            ),
            Align(
              alignment: Alignment(0, -0.9),
              child: AnimatedOpacity(
                opacity: model.showHelpMessage ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                      color: kcCultured,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(12.0),
                  width: screenWidth(context, percentage: 0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InsideOutText.headingFour(
                        "Can't find the credits?",
                        align: TextAlign.center,
                      ),
                      verticalSpaceSmall,
                      InsideOutButton(
                        title: "Collect immediately",
                        onTap: model.handleCollectedArObjectEvent,
                        trailing: Icon(Icons.arrow_forward,
                            size: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.7),
              child: Container(
                decoration: BoxDecoration(
                    color: kcCultured, borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(12.0),
                width: screenWidth(context, percentage: 0.7),
                child: InsideOutText.headingFour(
                  "Look around and tap the credits",
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
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty.image(kInsideOutLogoPath),
      blendMode: ARKitBlendMode.alpha,
    );
    final material2 = ARKitMaterial(
      //lightingModelName: ARKitLightingModel.blinn,
      diffuse: ARKitMaterialProperty.color(kcCultured),
      transparency: 0.5,
    );
    final box = ARKitBox(materials: [
      material2,
      material,
      material2,
      material,
      material2,
      material2,
    ], width: 0.12, height: 1, length: 1, chamferRadius: 0.5);
    final box2 = ARKitBox(materials: [
      material2,
    ], width: 0.11, height: 0.99, length: 0.99, chamferRadius: 0.5);

    // random position
    double ranX =
        (1 + ran.nextDouble() * 3) * (ran.nextDouble() > 0.5 ? -1 : 1);
    double ranZ = -1.5 - ran.nextDouble() * 2;

    final node = ARKitNode(
      geometry: box,
      position: vector.Vector3(ranX, -1, ranZ),
      //position: vector.Vector3(0, -1, -4),
    );
    final node2 = ARKitNode(
      geometry: box2,
      position: vector.Vector3(ranX, -1, ranZ),
      //position: vector.Vector3(0, -1, -4),
    );

    this.arkitController.add(node);
    this.arkitController.add(node2);

    timer = Timer.periodic(
      const Duration(milliseconds: 25),
      (timer) {
        final rotation = node.eulerAngles;
        rotation.x += 0.025;
        node.eulerAngles = rotation;
        node2.eulerAngles = rotation;
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
