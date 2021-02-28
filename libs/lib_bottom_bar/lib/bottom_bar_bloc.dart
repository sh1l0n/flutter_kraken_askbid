//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_bottombar package
//

import 'package:flutter/material.dart';

class CustomBottomBarItemModel {
  const CustomBottomBarItemModel(
      {@required this.title, @required this.route, @required this.icon});
  final String title;
  final String route;
  final IconData icon;
}

class CustomBottomBarBLoC {
  CustomBottomBarBLoC(this.categories);

  final List<CustomBottomBarItemModel> categories;

  int _selected = 0;
  int get selected => _selected;

  void selectCategory(final BuildContext context, final int id) {
    if (id >= 0 && id < categories.length && selected != id) {
      _selected = id;
      if (Navigator.canPop(context)) {
        Navigator.pushReplacementNamed(context, categories[selected].route);
      } else {
        Navigator.pushNamed(context, categories[selected].route);
      }
    }
  }
}
