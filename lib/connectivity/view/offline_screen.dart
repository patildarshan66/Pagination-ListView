import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/no_internet_connection.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
