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

class OrderBookLinesGraph extends OrderBookGraph {
  const OrderBookLinesGraph(
      {Key key,
      @required OrderBookGraphStyle style,
      @required OrderBookGraphBloc bloc,
      @required List<OrderWrapper> asks,
      @required List<OrderWrapper> bids,
      @required double maxValueY})
      : super(
            key: key,
            style: style,
            bloc: bloc,
            asks: asks,
            bids: bids,
            maxValueY: maxValueY);

  @override
  charts.SeriesRendererConfig<DateTime> generateRender() {
    return charts.LineRendererConfig(
      roundEndCaps: true,
      strokeWidthPx: 1,
      radiusPx: 2,
      includePoints: true,
    );
  }
}
