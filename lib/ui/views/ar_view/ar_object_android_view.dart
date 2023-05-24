import 'dart:math';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_viewmodel.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARObjectAndroidView extends StatefulWidget {
  final bool isCoins;
  ARObjectAndroidView({Key? key, this.isCoins = false}) : super(key: key);

  @override
  _ARObjectAndroidViewState createState() => _ARObjectAndroidViewState();
}

class _ARObjectAndroidViewState extends State<ARObjectAndroidView> {
  late ArCoreController arCoreController;
  final log = getLogger("ARObjectView");
  final ran = Random();
  ArCorePlane? currentPlane;
  Map<String, int> objectHits = {};
  bool isShowingTreasure = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ARObjectViewModel>.reactive(
      viewModelBuilder: () => ARObjectViewModel(),
      //onModelReady: (model) => model.wait(),
      builder: (context, model, _) => MainPage(
        onBackPressed: () => model.popArView(result: false),
        child: Stack(
          children: [
            ArCoreView(
              onArCoreViewCreated: (ArCoreController controller) =>
                  _onArCoreViewCreated(
                      controller, model.handleCollectedArObjectEvent),

              enableTapRecognizer: true,

              // test whether this is needed!
              enableUpdateListener: !widget.isCoins,

              // enable for treasure mode
              enablePlaneRenderer: !widget.isCoins,
            ),
            if (widget.isCoins)
              Align(
                alignment: Alignment(0, 0.7),
                child: Container(
                  decoration: BoxDecoration(
                      color: kcCultured,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8.0),
                  width: screenWidth(context, percentage: 0.7),
                  child: InsideOutText.headingThree(
                    "Find credits and tap fast to collect",
                    align: TextAlign.center,
                  ),
                ),
              ),
            if (!widget.isCoins)
              Align(
                alignment: Alignment(0, 0.7),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: isShowingTreasure
                      ? InsideOutText.successThree(
                          "Congratz! Tap to collect the treasure",
                          align: TextAlign.center,
                        )
                      : currentPlane == null
                          ? InsideOutText.headingThree("Find a surface")
                          : InsideOutText.headingThree("Tap to show treasure"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller,
      Future Function() handleCollectedArObjectEvent) async {
    arCoreController = controller;
    if (!widget.isCoins)
      arCoreController.onPlaneDetected = (ArCorePlane plane) async {
        //log.i("Plane found!");
        currentPlane = plane;
        if (!isShowingTreasure &&
            currentPlane != null &&
            currentPlane!.centerPose != null) {
          isShowingTreasure = true;
          final pos = currentPlane!.centerPose!.translation;
          final rot = currentPlane!.centerPose!.rotation;
          _addTreasure(controller, pos, rot);
          setState(() {});
        }
      };
    // if (!widget.isCoins) {
    //   arCoreController.onPlaneTap = (List<ArCoreHitTestResult> hits) async {
    //     log.wtf("ON PLANE TAPPED!");
    //     if (currentPlane != null && currentPlane!.centerPose != null) {
    //       final pos =
    //           vector.Vector3.zero() + currentPlane!.centerPose!.translation;
    //       _addTreasure(controller, pos);
    //     }
    //   };
    // }
    controller.onNodeTap = (String nodeString) async {
      log.i("Tapped coin!");
      if (objectHits.containsKey(nodeString)) {
        objectHits[nodeString] = objectHits[nodeString]! + 1;
        if (objectHits[nodeString]! > 0) {
          await handleCollectedArObjectEvent();
          controller.removeNode(nodeName: nodeString);
        }
      } else {
        objectHits[nodeString] = 1;
      }
    };
    // _addSphere(arCoreController);
    // _addCylindre(arCoreController);
    // _addCube(arCoreController);
    if (widget.isCoins) _addRotatingLogo(controller);
    // _addRotatingLogo(controller);
    //_addTreasure(controller);
  }

  void _addRotatingLogo(ArCoreController controller,
      [vector.Vector3? position]) async {
    // afk logo
    final logoAsBundle = await rootBundle.load(kInsideOutLogoPath);
    final logoAsUint8 = logoAsBundle.buffer.asUint8List();
    final imageMaterial = ArCoreMaterial(
      textureBytes: logoAsUint8,
      color: kcPrimaryColor,
    );

    // Cube
    final cube = ArCoreCube(
      materials: [imageMaterial],
      size: vector.Vector3(0.04, 0.6, 0.6),
    );
    await Future.delayed(Duration(milliseconds: 1400));
    double ranX =
        (1 + ran.nextDouble() * 3) * (ran.nextDouble() > 0.5 ? -1 : 1);
    double ranZ = -1.5 - ran.nextDouble() * 2;
    final rotatingCube = ArCoreRotatingNode(
      degreesPerSecond: 360,
      shape: cube,
      // position: position ?? vector.Vector3(ranX, -1, ranZ),
      position: vector.Vector3(ranX, -1, ranZ),

      // +z direction is backwards
    );
    controller.addArCoreNode(rotatingCube);
  }

  _addTreasure(ArCoreController controller,
      [vector.Vector3? position, vector.Vector4? rotation]) async {
    final logoAsBundle = await rootBundle.load(kTreasureIconARPath);
    final logoAsUint8 = logoAsBundle.buffer.asUint8List();
    final imageMaterial = ArCoreMaterial(
      textureBytes: logoAsUint8,
      color: kcPrimaryColor,
      roughness: 0,
    );
    // Cube
    final cube = ArCoreCube(
      materials: [imageMaterial],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    // final v = vector.Vector3(
    //     -0.10801953077316284, -0.9932498931884766, -2.4462766647338867);
    // await Future.delayed(Duration(milliseconds: 1400));
    final rotatingCube = ArCoreNode(
      shape: cube,
      position: position ?? vector.Vector3(0, -1, -1.5),
      rotation: rotation,
    );
    controller.addArCoreNode(rotatingCube);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
