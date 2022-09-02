import 'dart:io';
import 'dart:math';

import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/buttons_layouts.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:afkcredits/app/app.logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';

class ARObjectView extends StatefulWidget {
  final bool isCoins;
  ARObjectView({Key? key, this.isCoins = false}) : super(key: key);

  @override
  _ARObjectViewState createState() => _ARObjectViewState();
}

class _ARObjectViewState extends State<ARObjectView> {
  //late ArCoreController arCoreController;
  final log = getLogger("ARObjectView");
  final ran = Random();
  Map<String, int> objectHits = {};
  bool isShowingTreasure = false;

  // For new plugin
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ARObjectViewModel>.reactive(
      viewModelBuilder: () => ARObjectViewModel(),
      builder: (context, model, _) => MainPage(
        onBackPressed: () => model.popArView(result: false),
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              //laneDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            // ArCoreView(
            //   onArCoreViewCreated: (ArCoreController controller) =>
            //       _onArCoreViewCreated(
            //           controller, model.handleCollectedArObjectEvent),

            //   enableTapRecognizer: true,

            //   // test whether this is needed!
            //   enableUpdateListener: !widget.isCoins,

            //   // enable for treasure mode
            //   enablePlaneRenderer: !widget.isCoins,
            // ),
            if (widget.isCoins)
              Align(
                alignment: Alignment(0, 0.7),
                child: Container(
                  decoration: BoxDecoration(
                      color: kcCultured,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8.0),
                  width: screenWidth(context, percentage: 0.7),
                  child: AfkCreditsText.headingThree(
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
                    child: AfkCreditsText.successThree(
                      "Congratz! Tap to collect the treasure",
                      align: TextAlign.center,
                    )),
              ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );
    arObjectManager.onInitialize();

    //Download model to file system
    httpClient = new HttpClient();
    _downloadAndUnpack(
        url:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        filename: "LocalDuck.glb");
    // Alternative to use type fileSystemAppFolderGLTF2:
    //_downloadAndUnpack(
    //    "https://drive.google.com/uc?export=download&id=1fng7yiK0DIR0uem7XkV2nlPSGH9PysUs",
    //    "Chicken_01.zip");
  }

  Future<void> _downloadAndUnpack(
      {required String url, required String filename}) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    print("Downloading finished, path: " + '$dir/$filename');

    // To print all files in the directory: print(Directory(dir).listSync());
    try {
      await ZipFile.extractToDirectory(
          zipFile: File('$dir/$filename'), destinationDir: Directory(dir));
      print("Unzipping successful");
    } catch (e) {
      print("Unzipping failed: " + e.toString());
    }
  }

  // For old plugin
  // void _onArCoreViewCreated(ArCoreController controller,
  //     Future Function() handleCollectedArObjectEvent) {
  //   arCoreController = controller;
  //   if (!widget.isCoins)
  //     arCoreController.onPlaneDetected = (ArCorePlane plane) async {
  //       //log.i("Plane found!");
  //       currentPlane = plane;
  //       if (!isShowingTreasure &&
  //           currentPlane != null &&
  //           currentPlane!.centerPose != null) {
  //         isShowingTreasure = true;
  //         final pos = currentPlane!.centerPose!.translation;
  //         final rot = currentPlane!.centerPose!.rotation;
  //         _addTreasure(controller, pos, rot);
  //         setState(() {});
  //       }
  //     };
  //   // if (!widget.isCoins) {
  //   //   arCoreController.onPlaneTap = (List<ArCoreHitTestResult> hits) async {
  //   //     log.wtf("ON PLANE TAPPED!");
  //   //     if (currentPlane != null && currentPlane!.centerPose != null) {
  //   //       final pos =
  //   //           vector.Vector3.zero() + currentPlane!.centerPose!.translation;
  //   //       _addTreasure(controller, pos);
  //   //     }
  //   //   };
  //   // }
  //   controller.onNodeTap = (String nodeString) async {
  //     log.i("Tapped coin!");
  //     if (objectHits.containsKey(nodeString)) {
  //       objectHits[nodeString] = objectHits[nodeString]! + 1;
  //       if (objectHits[nodeString]! > 40) {
  //         await handleCollectedArObjectEvent();
  //         controller.removeNode(nodeName: nodeString);
  //       }
  //     } else {
  //       objectHits[nodeString] = 1;
  //     }
  //   };
  //   // _addSphere(arCoreController);
  //   // _addCylindre(arCoreController);
  //   // _addCube(arCoreController);
  //   if (widget.isCoins) _addRotatingLogo(controller);
  //   // _addRotatingLogo(controller);
  //   //_addTreasure(controller);
  // }

  // void _addRotatingLogo(ArCoreController controller,
  //     [vector.Vector3? position]) async {
  //   // afk logo
  //   final logoAsBundle = await rootBundle.load(kAFKCreditsLogoPath);
  //   final logoAsUint8 = logoAsBundle.buffer.asUint8List();
  //   final imageMaterial = ArCoreMaterial(
  //     textureBytes: logoAsUint8,
  //     color: kcPrimaryColor,
  //   );

  //   // Cube
  //   final cube = ArCoreCube(
  //     materials: [imageMaterial],
  //     size: vector.Vector3(0.04, 0.6, 0.6),
  //   );
  //   await Future.delayed(Duration(milliseconds: 1400));
  //   double ranX =
  //       (1 + ran.nextDouble() * 3) * (ran.nextDouble() > 0.5 ? -1 : 1);
  //   double ranZ = -1.5 - ran.nextDouble() * 2;
  //   final rotatingCube = ArCoreRotatingNode(
  //     degreesPerSecond: 360,
  //     shape: cube,
  //     // position: position ?? vector.Vector3(ranX, -1, ranZ),
  //     position: vector.Vector3(ranX, -1, ranZ),

  //     // +z direction is backwards
  //   );
  //   controller.addArCoreNode(rotatingCube);
  // }

  // _addTreasure(ArCoreController controller,
  //     [vector.Vector3? position, vector.Vector4? rotation]) async {
  //   final logoAsBundle = await rootBundle.load(kTreasureIconARPath);
  //   final logoAsUint8 = logoAsBundle.buffer.asUint8List();
  //   final imageMaterial = ArCoreMaterial(
  //     textureBytes: logoAsUint8,
  //     color: kcPrimaryColor,
  //     roughness: 0,
  //   );
  //   // Cube
  //   final cube = ArCoreCube(
  //     materials: [imageMaterial],
  //     size: vector.Vector3(0.5, 0.5, 0.5),
  //   );
  //   // final v = vector.Vector3(
  //   //     -0.10801953077316284, -0.9932498931884766, -2.4462766647338867);
  //   // await Future.delayed(Duration(milliseconds: 1400));
  //   final rotatingCube = ArCoreNode(
  //     shape: cube,
  //     position: position ?? vector.Vector3(0, -1, -1.5),
  //     rotation: rotation,
  //   );
  //   controller.addArCoreNode(rotatingCube);
  // }

  @override
  void dispose() {
    // arCoreController.dispose();
    arSessionManager?.dispose();

    super.dispose();
  }
}
