//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:lib_bottom_bar/bottom_bar_bloc.dart';
import 'package:lib_charts/order_book/orderbook_bars_graph.dart';
import 'package:lib_charts/order_book/orderbook_graph_bloc.dart';
import 'package:lib_charts/order_book/orderbook_graph.dart';
import 'package:lib_ddbb/cache/kraken_cache.dart';

import 'base_chart/base_chart_screen.dart';
import 'base_chart/base_chart_screen_bloc.dart';

class BooksAmountBarsScreen extends BaseChartScreen {
  const BooksAmountBarsScreen(
      {@required final CustomBottomBarBLoC bottomBarBloc,
      @required OrderBookGraphBloc orderBookBloc,
      @required BaseChartScreenBLoC chartScreenBloc})
      : super(
            bottomBarBloc: bottomBarBloc,
            orderBookBloc: orderBookBloc,
            chartScreenBloc: chartScreenBloc);

  static String get route => '/amount_bars';

  @override
  State<StatefulWidget> createState() => _BooksAmountScreenState();
}

class _BooksAmountScreenState extends BaseChartScreenState {
  @override
  OrderBookGraph generateGraph() {
    return OrderBookBarsGraph(
      bloc: bloc,
      asks: KrakenMemoryCache().asks,
      bids: KrakenMemoryCache().bids,
      maxValueY: KrakenMemoryCache().maxValueY,
      style: OrderBookGraphStyle(
        axisLineWidth: 1,
        axisFontColor: charts.MaterialPalette.white,
        axisLineColor: charts.MaterialPalette.white,
        bidLineColor: charts.MaterialPalette.lime.shadeDefault,
        askLineColor: charts.MaterialPalette.pink.shadeDefault,
        chartBackgroundColor: Color(0xff565656),
      ),
    );
  }
}
