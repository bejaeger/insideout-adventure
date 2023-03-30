import 'dart:async';

import 'package:afkcredits/enums/connectivity_type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamController<ConnectivityType> connectionStatusController =
      StreamController<ConnectivityType>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        var status = _getStatusFromResult(result);
        connectionStatusController.add(status);
      },
    );
  }

  ConnectivityType _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityType.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityType.WiFi;
      case ConnectivityResult.none:
        return ConnectivityType.Offline;
      default:
        return ConnectivityType.Offline;
    }
  }
}
