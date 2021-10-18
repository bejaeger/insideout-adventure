import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/layout/afk_bottom_navigation_bar_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AFKBottomNavigationBar extends StatelessWidget {
  final double height;
  final double opacity;
  const AFKBottomNavigationBar(
      {Key? key, this.height = kBottomNavigationBarHeight, this.opacity = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AFKBottomNavigationBarViewModel>.reactive(
        viewModelBuilder: () => AFKBottomNavigationBarViewModel(),
        builder: (context, model, child) => AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: opacity,
              child: AnimatedContainer(
                duration: model.showBottomNavBar
                    ? Duration(milliseconds: 100)
                    : Duration(milliseconds: 100),
                curve: model.showBottomNavBar ? Curves.easeIn : Curves.easeIn,
                //transform: ,
                // Could also use Visibility widget here to hide navbar
                height: model.showBottomNavBar ? height : 0,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: height,
                            width: screenWidth(context, percentage: 0.5),
                            color: model.isOnHome
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth(context, percentage: 0.5),
                            child: IconButton(
                              onPressed: model.onHomePressed,
                              icon: Icon(Icons.home,
                                  size: kBottomNavigationBarIconSize,
                                  color: kBottomNavigationBarIconColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: height,
                            width: screenWidth(context, percentage: 0.5),
                            color: model.isOnMap
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth(context, percentage: 0.5),
                            child: IconButton(
                              onPressed: model.onMapPressed,
                              icon: Icon(Icons.explore,
                                  size: kBottomNavigationBarIconSize,
                                  color: kBottomNavigationBarIconColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: height,
                            width: screenWidth(context, percentage: 0.5),
                            color: model.isOnGift
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth(context, percentage: 0.5),
                            child: IconButton(
                              onPressed: model.onGiftPressed,
                              icon: Icon(Icons.card_giftcard,
                                  size: kBottomNavigationBarIconSize,
                                  color: kBottomNavigationBarIconColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        //: Container(height: 0, width: 0)
        );
  }
}
