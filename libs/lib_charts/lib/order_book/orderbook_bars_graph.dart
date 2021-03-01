//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_charts module
//

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:lib_model/order.dart';

import 'orderbook_graph_bloc.dart';
import 'orderbook_graph.dart';

class OrderBookBarsGraph extends OrderBookGraph {
  const OrderBookBarsGraph(
      {Key key,
      @required OrderBookGraphStyle style,
      @required OrderBookGraphBloc bloc,
      @required List<OrderWrapper> bids,
      @required List<OrderWrapper> asks,
      @required double maxValueY})
      : super(
            key: key,
            style: style,
            bloc: bloc,
            bids: bids,
            asks: asks,
            maxValueY: maxValueY);

  @override
  charts.SeriesRendererConfig<DateTime> generateRender() {
    return charts.BarRendererConfig<DateTime>();
  }
}
