import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';

class LayoutService {
  BehaviorSubject<bool> showBottomNavBarSubject =
      BehaviorSubject<bool>.seeded(false);
  bool get showBottomNavBar => showBottomNavBarSubject.value!;

  void setShowBottomNavBar(bool show) {
    showBottomNavBarSubject.add(show);
  }
}
