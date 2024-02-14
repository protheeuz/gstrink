import 'package:flutter/material.dart';

import '../declaration/constants.dart';


AppBar buildAppBar({
  required String appBarTitle,
  bool? centerTitle,
  List<Widget>? actionsWidget,
}) => AppBar(
  title: Text(appBarTitle),
  centerTitle: centerTitle ?? true,
  elevation: 0,

  backgroundColor: primaryColor,
  actions: actionsWidget ?? [],
);