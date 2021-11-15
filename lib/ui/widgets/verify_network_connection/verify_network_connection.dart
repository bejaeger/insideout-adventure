import 'package:afkcredits/enums/connectivity_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../views/network_connection/no_network_connection_view.dart';

class VerifyNetworkConnection extends StatelessWidget {
  final Widget child;
  VerifyNetworkConnection({
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityType>(context);

    if (connectionStatus == ConnectivityType.WiFi ||
        connectionStatus == ConnectivityType.Cellular) {
      return child;
    }
    // return Opacity(opacity: 0.1,child: child,);  }
    return NoNetworkConnectionView();
  }
}
