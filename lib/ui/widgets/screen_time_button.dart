import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ScreenTimeButton extends StatelessWidget {
  final Future Function() onPressed;
  final String title;
  final String? imageUrl;
  final String? imagePath;
  final Color backgroundColor;
  final Color titleColor;
  final int credits;
  final double? height;
  const ScreenTimeButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.credits,
    this.backgroundColor = kcOrange,
    this.titleColor = kcGreyTextColor,
    this.imageUrl,
    this.imagePath,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          height: 140,
          width: 120,
          clipBehavior: Clip.antiAlias,
          //padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: backgroundColor,
            // boxShadow: [
            //   BoxShadow(
            //     blurRadius: 2,
            //     color: kShadowColor,
            //     spreadRadius: 0.5,
            //     offset: Offset(1, 1),
            //   )
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Container(
                  width: 100,
                  height: 60,
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FadeInImage.memoryNetwork(
                    fadeInDuration: Duration(milliseconds: 200),
                    placeholder: kTransparentImage,
                    image: imageUrl!,
                  ),
                ),
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          imagePath!,
                        ),
                      ),
                    ),
                  ),
                ),
              verticalSpaceSmall,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment(0, -0.4),
                  child: Text(
                    title,
                    style: textTheme(context)
                        .headline6!
                        .copyWith(color: titleColor),
                  ),
                ),
              ),
              //Icon(Icons.arrow_forward_ios, color: titleColor),
              //Spacer(),
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AFKCreditsIcon(height: 25),
                    Text(credits.toString(),
                        style: TextStyle(color: kcPrimaryColor)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
