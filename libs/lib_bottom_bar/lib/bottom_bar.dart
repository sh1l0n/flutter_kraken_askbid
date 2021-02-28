//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_bottombar package
//

import 'package:flutter/material.dart';

import 'bottom_bar_bloc.dart';

class CustomBottomBarStyle {
  const CustomBottomBarStyle({
    @required this.selectedLabelStyle,
    @required this.selectedItemColor,
    @required this.unselectedLabelStyle,
    @required this.unselectedItemColor,
    @required this.backgroundColor,
  });
  final Color backgroundColor;
  final TextStyle selectedLabelStyle;
  final Color selectedItemColor;
  final TextStyle unselectedLabelStyle;
  final Color unselectedItemColor;
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key key, @required this.bloc, @required this.style})
      : super(key: key);

  final CustomBottomBarBLoC bloc;
  final CustomBottomBarStyle style;

  List<BottomNavigationBarItem> get items {
    List<BottomNavigationBarItem> _items = [];
    bloc.categories.forEach((element) {
      _items += [
        BottomNavigationBarItem(icon: Icon(element.icon), label: element.title)
      ];
    });
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      backgroundColor: style.backgroundColor,
      onTap: (final int index) {
        bloc.selectCategory(context, index);
      },
      currentIndex: bloc.selected,
      selectedLabelStyle: style.selectedLabelStyle,
      selectedItemColor: style.selectedItemColor,
      unselectedLabelStyle: style.unselectedLabelStyle,
      unselectedItemColor: style.unselectedItemColor,
    );
  }
}
