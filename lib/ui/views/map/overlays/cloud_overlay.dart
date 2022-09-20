import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

//
// Widget that overlays clouds on the map
//

class CloudOverlay extends StatelessWidget {
  final bool overlay;
  const CloudOverlay({Key? key, required this.overlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: overlay
              ? AnimatedOpacity(
                  opacity: 1,
                  // opacity: overlay == true ? 1 : 0,
                  duration: Duration(seconds: 1),
                  child: Container(
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: screenWidth(context),
                          color: Colors.blue,
                          child: Image.asset(
                            kCloudOverlayImagePath,
                            // "https://prooptimania.s3.us-east-2.amazonaws.com/ckfinder/images/luz-azul-cielo-azul.jpg",
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.65)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: [
                                  0.0,
                                  0.45,
                                  0.55,
                                  1.0,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: [
                        0.0,
                        0.5,
                        0.75,
                        1.0,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
