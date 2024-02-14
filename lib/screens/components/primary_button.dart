import 'package:flutter/material.dart';

import '../declaration/constants.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({super.key, required this.btnText, required this.btnFunc});
  final String btnText;
  final Function btnFunc;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => btnFunc(),
      style: getBtnStyle(context),
      child: Text(btnText),
    );
  }

  getBtnStyle(context) => ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius / 2),
      backgroundColor: Colors.white70,
      fixedSize: Size(MediaQuery.of(context).size.width - 40, 50),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
}
