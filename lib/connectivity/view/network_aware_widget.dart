import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../vm/network_status_checker.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({Key key, this.onlineChild, this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkStatus =
        Provider.of<VmNetworkStatus>(context).isConnected;
    if (networkStatus == true) {
      return onlineChild;
    } else {
      return offlineChild;
    }
  }
}