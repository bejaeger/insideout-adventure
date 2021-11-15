import 'dart:async';
import 'package:afkcredits/enums/connectivity_type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Create our public controller
  StreamController<ConnectivityType> connectionStatusController =
      StreamController<ConnectivityType>();

  //final Connectivity _connectivity = Connectivity();

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      var connectivityStatus = _getStatusFromResult(result);
      connectionStatusController.add(connectivityStatus);
    });
  }

  // Convert from the third part enum to our own enum
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
