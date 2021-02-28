//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'package:flutter/material.dart';
import 'package:lib_bottom_bar/bottom_bar_bloc.dart';
import 'package:lib_charts/order_book/orderbook_graph_bloc.dart';

import 'base_chart/base_chart_screen_bloc.dart';
import 'books_bars_screen.dart';
import 'books_lines_screen.dart';
import 'support.dart';

class NavigatorManagerItemModel extends CustomBottomBarItemModel {
  const NavigatorManagerItemModel(
      {@required final String title,
      @required final String route,
      @required final IconData icon})
      : super(title: title, route: route, icon: icon);
}

class NavigatorManagerBLoC extends CustomBottomBarBLoC {
  NavigatorManagerBLoC(List<NavigatorManagerItemModel> categories)
      : super(categories);

  final orderBookBlocLines = OrderBookGraphBloc(
      axisXFontMaxSize: 18,
      padding: 20,
      axisYFontSize: 12,
      tickLengthAxisY: 30,
      tickMaxLengthAxisX: 80);

  final orderBookBlocCharts = OrderBookGraphBloc(
      axisXFontMaxSize: 18,
      padding: 20,
      axisYFontSize: 12,
      tickLengthAxisY: 30,
      tickMaxLengthAxisX: 80);

  final chartScreenBloc = BaseChartScreenBLoC();
}

class NavigatorManager extends StatelessWidget {
  const NavigatorManager({Key key, @required this.navigationBloc})
      : super(key: key);
  final NavigatorManagerBLoC navigationBloc;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodCharts',
      initialRoute: BooksAmountLinesScreen.route,
      onGenerateRoute: (final RouteSettings settings) {
        final route = settings.name;
        if (route == BooksAmountLinesScreen.route) {
          return MaterialPageRoute(builder: (context) {
            return BooksAmountLinesScreen(
                bottomBarBloc: navigationBloc,
                orderBookBloc: navigationBloc.orderBookBlocLines,
                chartScreenBloc: navigationBloc.chartScreenBloc);
          });
        } else if (route == BooksAmountBarsScreen.route) {
          return MaterialPageRoute(builder: (context) {
            return BooksAmountBarsScreen(
                bottomBarBloc: navigationBloc,
                orderBookBloc: navigationBloc.orderBookBlocCharts,
                chartScreenBloc: navigationBloc.chartScreenBloc);
          });
        } else if (route == SupportScreen.route) {
          return MaterialPageRoute(builder: (context) {
            return SupportScreen(navigationBloc);
          });
        } else {
          return MaterialPageRoute(builder: (context) => Container());
        }
      },
    );
  }
}
