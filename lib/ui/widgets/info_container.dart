import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final Widget child;
  const InfoContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15.0),
          // border: Border.all(),
          border: Border.all(color: Colors.grey[400]!),
          // boxShadow: [
          //   BoxShadow(
          //       blurRadius: 1,
          //       spreadRadius: 0.3,
          //       offset: Offset(1, 1),
          //       color: kcShadowColor),
          // ],
        ),
        padding:
            const EdgeInsets.only(top: 12, right: 15, left: 15, bottom: 12.0),
        child: child);
  }
}
