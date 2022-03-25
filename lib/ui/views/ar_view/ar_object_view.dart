import 'dart:math';

import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/layout_widgets/buttons_layouts.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:afkcredits/app/app.logger.dart';

class ARObjectView extends StatefulWidget {
  final bool isCoins;
  ARObjectView({Key? key, this.isCoins = false}) : super(key: key);

  @override
  _ARObjectViewState createState() => _ARObjectViewState();
}

class _ARObjectViewState extends State<ARObjectView> {
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
      builder: (context, model, _) => MainPage(
        onBackPressed: model.popArView,
        child: Stack(
          children: [
            ArCoreView(
              onArCoreViewCreated: (ArCoreController controller) =>
                  _onArCoreViewCreated(
                      controller, model.showCollectedMarkerDialog),

              enableTapRecognizer: true,

              // test whether this is needed!
              enableUpdateListener: !widget.isCoins,

              // enable for treasure mode
              enablePlaneRenderer: !widget.isCoins,
            ),
            if (widget.isCoins)
              Align(
                alignment: Alignment(0, 0.7),
                child: AfkCreditsText.subheading(
                    "Find coins and tap fast to collect"),
              ),
            if (!widget.isCoins)
              Align(
                alignment: Alignment(0, 0.7),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: isShowingTreasure
                      ? AfkCreditsText.successThree(
                          "Congratz! Tap to collect the treasure",
                          align: TextAlign.center,
                        )
                      : currentPlane == null
                          ? AfkCreditsText.headingThree("Find a plane")
                          : AfkCreditsText.headingThree("Tap to show treasure"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller,
      Future Function() showCollectedMarkerDialog) {
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
        if (objectHits[nodeString]! > 40) {
          await showCollectedMarkerDialog();
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
    final logoAsBundle = await rootBundle.load(kAFKCreditsLogoPath);
    final logoAsUint8 = logoAsBundle.buffer.asUint8List();
    final imageMaterial = ArCoreMaterial(
      textureBytes: logoAsUint8,
      color: kPrimaryColor,
    );

    // Cube
    final cube = ArCoreCube(
      materials: [imageMaterial],
      size: vector.Vector3(0.04, 0.4, 0.4),
    );
    await Future.delayed(Duration(milliseconds: 1400));
    double ranX = ran.nextDouble() * 3 * (ran.nextDouble() > 0.5 ? -1 : 1);
    double ranZ = ran.nextDouble() * 3 * (ran.nextDouble() > 0.5 ? -1 : 1);
    final rotatingCube = ArCoreRotatingNode(
      degreesPerSecond: 360,
      shape: cube,
      position: position ?? vector.Vector3(ranX, -1, ranZ),
    );
    controller.addArCoreNode(rotatingCube);
  }

  _addTreasure(ArCoreController controller,
      [vector.Vector3? position, vector.Vector4? rotation]) async {
    final logoAsBundle = await rootBundle.load(kTreasureIconARPath);
    final logoAsUint8 = logoAsBundle.buffer.asUint8List();
    final imageMaterial = ArCoreMaterial(
      textureBytes: logoAsUint8,
      color: kPrimaryColor,
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
