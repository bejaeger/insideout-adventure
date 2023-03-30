import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class AFKCreditsIcon extends StatelessWidget {
  final bool locked;
  final double? height;
  final Alignment alignment;
  final Color? color;
  const AFKCreditsIcon({
    Key? key,
    this.locked = false,
    this.height,
    this.alignment = Alignment.center,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 70,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Align(
                alignment: alignment,
                child: Image.asset(kAFKCreditsLogoPath,
                    color: color, height: (height ?? 70) - 10.0),
              ),
              if (locked)
                Align(
                  alignment: locked ? Alignment.center : Alignment.bottomRight,
                  child: PhysicalModel(
                    color: Colors.grey[200]!.withOpacity(0.05),
                    elevation: 0,
                    shape: BoxShape.circle,
                    child: Icon(locked ? Icons.lock : Icons.lock_open,
                        size: 40, color: kcGreyTextColor),
                  ),
                )
            ],
          ),
        ));
  }
}
