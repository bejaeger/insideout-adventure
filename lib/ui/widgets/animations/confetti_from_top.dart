import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettieFromTop extends StatelessWidget {
  const ConfettieFromTop({
    Key? key,
    required ConfettiController confettiController,
  })  : _confettiController = confettiController,
        super(key: key);

  final ConfettiController _confettiController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConfettiWidget(
          maxBlastForce: 10,
          minBlastForce: 1,
          gravity: 0.15,
          //particleDrag: 0.1,
          confettiController: _confettiController,
          blastDirection: pi / 2,
          blastDirectionality: BlastDirectionality
              .directional, // don't specify a direction, blast randomly
          shouldLoop: true, // start again as soon as the animation is finished
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
          //createParticlePath: drawStar, // define a custom shape/path.
        ),
        ConfettiWidget(
          maxBlastForce: 10,
          minBlastForce: 1,
          gravity: 0.15,
          //particleDrag: 0.1,
          confettiController: _confettiController,
          blastDirection: pi / 2,
          blastDirectionality: BlastDirectionality
              .directional, // don't specify a direction, blast randomly
          shouldLoop: true, // start again as soon as the animation is finished
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
          //createParticlePath: drawStar, // define a custom shape/path.
        ),
      ],
    );
  }
}
