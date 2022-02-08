import 'package:flutter/material.dart';

abstract class PausableService {
  bool? _servicePaused;
  bool? get servicePaused => _servicePaused;

  @mustCallSuper
  void pause() {
    _servicePaused = true;
  }

  @mustCallSuper
  void resume() {
    _servicePaused = false;
  }
}
