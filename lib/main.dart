//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of Flutter-Kraken project
//

import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_ddbb/storage/database_helper.dart';
import 'package:lib_ddbb/storage/exchange.dart';
import 'package:lib_screens/books_bars_screen.dart';
import 'package:lib_screens/books_lines_screen.dart';

import 'package:lib_screens/navigator.dart';
import 'package:lib_screens/support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDatabase();
  runApp(NavigatorManager(navigationBloc: navigatorBloc));
}

final navigatorBloc = NavigatorManagerBLoC([
  NavigatorManagerItemModel(
      icon: Icons.line_style,
      title: 'Lines',
      route: BooksAmountLinesScreen.route),
  NavigatorManagerItemModel(
      icon: Icons.bar_chart,
      title: 'Bars',
      route: BooksAmountBarsScreen.route),
  NavigatorManagerItemModel(
      icon: Icons.support, title: 'Support', route: SupportScreen.route),
]);

Future<void> initializeDatabase() async {
  await DatabaseHelper().initialize();
  await ExchangeWrapperProvider.insertWithName('kraken');
  // await ExchangeWrapperProvider.insertWithName('bitfinex');
  await DatabaseHelper().close();
}

Future<void> initializeLanguage() async {
  final String lan = (await findSystemLocale()) ?? 'en_US';
  if (lan != 'es_ES') {
    Intl.defaultLocale = 'en_US';
  }
}
