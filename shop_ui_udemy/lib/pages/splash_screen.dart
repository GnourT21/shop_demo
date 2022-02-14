import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SpinKitRotatingCircle(
        duration: Duration(seconds: 1),
        color: Colors.amber,
        size: 50.0,
      ),
    );
  }
}
