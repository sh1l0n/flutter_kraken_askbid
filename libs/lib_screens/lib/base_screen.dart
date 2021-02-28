//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'package:flutter/material.dart';

import 'package:lib_bottom_bar/bottom_bar.dart';
import 'package:lib_bottom_bar/bottom_bar_bloc.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key key, @required this.bottomBarBloc}) : super(key: key);

  final CustomBottomBarBLoC bottomBarBloc;

  static String get route => '/';

  @override
  State<StatefulWidget> createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final size = Size(_size.width, _size.height - 50 - 50);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xff424242),
          leading: Container(),
          leadingWidth: 0,
          title: Text(
            widget
                .bottomBarBloc.categories[widget.bottomBarBloc.selected].title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Monserrat',
                package: 'lib_assets'),
          ),
        ),
      ),
      body: buildBody(context, size),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: CustomBottomBar(
          bloc: widget.bottomBarBloc,
          style: CustomBottomBarStyle(
              selectedLabelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Monserrat',
                  package: 'lib_assets'),
              selectedItemColor: Color(0xffffffff),
              unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Monserrat',
                  package: 'lib_assets'),
              unselectedItemColor: Color(0xff696969),
              backgroundColor: Color(0xff424242)),
        ),
      ),
    );
  }

  Widget buildBody(final BuildContext context, final Size size) {
    return Container(width: size.width, height: size.height);
  }
}
