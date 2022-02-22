import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class LargeButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final String? imageUrl;
  final String? imagePath;
  final Color backgroundColor;
  final Color titleColor;
  final double fontSize;
  const LargeButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = kNiceOrange,
    this.titleColor = kGreyTextColor,
    this.imageUrl,
    this.imagePath,
    this.fontSize = 22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(12.0),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (imageUrl != null)
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: FadeInImage.memoryNetwork(
                        fadeInDuration: Duration(milliseconds: 200),
                        placeholder: kTransparentImage,
                        image: imageUrl!,
                        fit: BoxFit.fitHeight),
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
              Expanded(
                child: Text(title,
                    style: textTheme(context)
                        .headline6!
                        .copyWith(color: titleColor, fontSize: fontSize)),
              ),
              Icon(Icons.arrow_forward_ios, color: titleColor),
            ],
          ),
        ),
      ),
    );
  }
}
