//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'package:flutter/widgets.dart';
import 'package:lib_bottom_bar/bottom_bar_bloc.dart';

import 'base_screen.dart';

class SupportScreen extends BaseScreen {
  SupportScreen(final CustomBottomBarBLoC bottomBarBloc)
      : super(bottomBarBloc: bottomBarBloc);

  static String get route => '/support';

  @override
  State<StatefulWidget> createState() => _SupportScreenState();
}

class _SupportScreenState extends BaseScreenState {
  String get title => 'Welcome to Kraken bid/ask app';

  String get message => '''

Check the differences between the amount of the first bid and ask marker orders every 2seconds in Kraken Exchange.

You can set fullscreen or follow last viewports.

The data is cleared before every run action.

You can scroll and zoom in the graph.
  ''';

  String get contact => 'https://github.com/sh1l0n';

  @override
  Widget buildBody(final BuildContext context, final Size size) {
    return Container(
      width: size.width,
      height: size.height,
      color: Color(0xff747474),
      child: Center(
        child: Container(
            width: size.width * 0.5,
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xffefefef),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Monserrat',
                    package: 'lib_assets',
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xffcecece),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Monserrat',
                    package: 'lib_assets',
                  ),
                ),
                Text(
                  contact,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffacacac),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Monserrat',
                    package: 'lib_assets',
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
