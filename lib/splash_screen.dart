import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Loading...',
            style:
                TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
