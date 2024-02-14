import 'package:flutter/material.dart';

class HeightSpacer extends StatelessWidget {
  final double myHeight;

  const HeightSpacer({super.key, required this.myHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: myHeight,
    );
  }
}

class WidthSpacer extends StatelessWidget {
  final double myWidth;
  const WidthSpacer({super.key, required this.myWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: myWidth,
    );
  }
}
