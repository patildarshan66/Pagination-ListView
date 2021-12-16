import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class VmNetworkStatus with ChangeNotifier {
  bool isConnected = true;
  StreamController<bool> networkStatusController = StreamController<bool>();

  Future<bool> checkNetwork() async {
    bool networkStatus = false;
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        networkStatus = true;
      }
    } on SocketException catch (_) {
      networkStatus = false;
    }
    return networkStatus;
  }

  VmNetworkStatus() {
    Connectivity().onConnectivityChanged.listen((status) async {
      networkStatusController.add(await _getNetworkStatus());
      isConnected = await _getNetworkStatus();
      notifyListeners();
    });
  }

  Future<bool> _getNetworkStatus() async {
    return await checkNetwork();
  }
}
