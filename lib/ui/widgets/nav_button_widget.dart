import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';

class NavButtonWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  final double padding;
  final void Function() onTap;
  const NavButtonWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.padding = 20.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black26,
                  spreadRadius: 1,
                  offset: Offset(3, 3),
                )
              ],
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: icon,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: kDarkTurquoise,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
