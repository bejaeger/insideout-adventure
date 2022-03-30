import 'package:afkcredits/ui/views/step_counter/step_counter_overlay_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StepCounterOverlay extends StatelessWidget {
  const StepCounterOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StepCounterOverlayViewModel>.reactive(
      viewModelBuilder: () => StepCounterOverlayViewModel(),
      builder: (context, model, child) => Align(
        alignment: Alignment(-1, 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                width: 80,
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: AfkCreditsText.headingOne(model.count)),
            Container(
                height: 100,
                width: 80,
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: AfkCreditsText.body(model.pedestrianStatus)),
            GestureDetector(
              onTap:
                  model.isCounting ? model.stopPedometer : model.startPedometer,
              child: Container(
                  height: 100,
                  width: 80,
                  color: model.isCounting ? Colors.red : Colors.green,
                  alignment: Alignment.center,
                  child: model.isCounting
                      ? AfkCreditsText.body("Stop counter")
                      : AfkCreditsText.body("Start counter")),
            ),
          ],
        ),
      ),
    );
  }
}
