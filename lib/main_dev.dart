import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/main_common.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_service.dart';
import 'package:afkcredits/slide_show_viewmodel.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'firebase_options_dev.dart' as dev;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      // not in agreement with GoogleService.plist warning appears
      // for iOS run in prod mode for now!
      await Firebase.initializeApp(
          name: Platform.isIOS ? "Dev" : null,
          options: dev.DefaultFirebaseOptions.currentPlatform);
    } else {
      await Firebase.initializeApp(
          options: dev.DefaultFirebaseOptions.currentPlatform);
    }

    mainCommon(Flavor.dev);

    //-------------------------------------
    // PLAYGROUND
    // setupLocator();
    // runApp(MyApp());
    // -----------------------------------

  } catch (e) {
    print(
        "ERROR: App main function failed in main_dev.dart with error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Be funny!",
      theme: ThemeData(
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: getRaisedButtonStyle()),
        primaryColor: kcPrimaryColor,
        appBarTheme: AppBarTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            color: kcPrimaryColor,
            elevation: 5,
            toolbarHeight: 80,
            centerTitle: true),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: kcPrimaryColor,
            ),
        primaryIconTheme: IconThemeData(color: Colors.white),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
              // color of app bar title
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3),
        ),
      ),
      // navigatorKey: StackedService.navigatorKey,
      // onGenerateRoute: StackedRouter().onGenerateRoute,

      ///////////////////////////
      /// Use the following with the AFK Custom bottom nav bar
      // builder: (context, child) => LayoutTemplateView(childView: child!),

      /////////////////////////////
      /// Use this when persistent nav bar is used
      home: SlideShowView(),
    );
  }
}

class SlideShowView extends StatefulWidget {
  const SlideShowView({Key? key}) : super(key: key);

  @override
  State<SlideShowView> createState() => _SlideShowViewState();
}

class _SlideShowViewState extends State<SlideShowView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SlideShowViewModel>.reactive(
      viewModelBuilder: () => SlideShowViewModel(),
      onModelReady: (model) => model.getPictures(),
      builder: (context, model, child) => Scaffold(
        floatingActionButton: AFKFloatingActionButton(
          icon: Icon(Icons.add, color: Colors.white),
          // width: 140,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          // title: "Kids area",
          onPressed: () => model.handleAddPicture(context),
        ),
        body: Container(
          height: screenHeight(context),
          width: screenWidth(context),
          color: Colors.black87,
          child: model.pictures.length > 0
              ? Container(
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kcCultured,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: model.pictures.length,
                    itemBuilder: (context, idx) {
                      return Column(
                        children: [
                          verticalSpaceSmall,
                          AfkCreditsText.headingFour(idx.toString()),
                          verticalSpaceSmall,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                Image.memory(model.pictures[idx], height: 320),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Hello! Add some pictures ;)",
                    style: heading1Style.copyWith(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            if (!mounted) return;
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      floatingActionButton: AFKFloatingActionButton(
        icon: Icon(Icons.add, color: Colors.white),
        // width: 140,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: "Add",
        onPressed: () async => await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SlideShowView(),
          ),
        ),
      ),
      body: Container(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Image.file(
          File(imagePath),
        ),
      ),
    );
  }
}
