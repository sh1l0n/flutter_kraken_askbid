//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_charts module
//

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:lib_model/order.dart';

import '../behaviour/common_pan_control_behaviour.dart';
import '../behaviour/zoom_pan_control_behaviour.dart';
import 'orderbook_graph_bloc.dart';

class OrderBookGraphStyle {
  const OrderBookGraphStyle(
      {@required this.axisLineWidth,
      @required this.axisLineColor,
      @required this.axisFontColor,
      @required this.chartBackgroundColor,
      @required this.bidLineColor,
      @required this.askLineColor});
  final int axisLineWidth;
  final charts.Color axisLineColor;
  final charts.Color axisFontColor;
  final Color chartBackgroundColor;

  final charts.Color bidLineColor;
  final charts.Color askLineColor;
}

abstract class OrderBookGraph extends StatelessWidget {
  const OrderBookGraph(
      {Key key,
      @required this.style,
      @required this.bloc,
      @required this.bids,
      @required this.asks,
      @required this.maxValueY})
      : super(key: key);
  final OrderBookGraphStyle style;
  final OrderBookGraphBloc bloc;
  final List<OrderWrapper> bids;
  final List<OrderWrapper> asks;
  final double maxValueY;

  List<charts.Series<OrderWrapper, DateTime>> generateData() {
    return [
      charts.Series<OrderWrapper, DateTime>(
          id: 'Bids',
          colorFn: (_, __) => style.bidLineColor,
          domainFn: (OrderWrapper order, _) =>
              DateTime.fromMillisecondsSinceEpoch(order.timestamp),
          measureFn: (OrderWrapper order, _) => order.amount,
          data: bids),
      charts.Series<OrderWrapper, DateTime>(
          id: 'Asks',
          colorFn: (_, __) => style.askLineColor,
          domainFn: (OrderWrapper order, _) =>
              DateTime.fromMillisecondsSinceEpoch(order.timestamp),
          measureFn: (OrderWrapper order, _) => order.amount,
          data: asks)
    ];
  }

  charts.DateTimeTickProviderSpec generateXAxisSpec() {
    // ignore: omit_local_variable_types
    List<charts.TickSpec<DateTime>> timers = [];
    for (var i = 0; i < bids.length; i++) {
      final serie = bids[i];
      final time = DateTime.fromMillisecondsSinceEpoch(serie.timestamp);
      // final label = '$i';
      final label = '${time.hour}:${time.minute}:${time.second}';
      timers += [charts.TickSpec<DateTime>(time, label: label)];
    }
    return charts.StaticDateTimeTickProviderSpec(timers);
  }

  charts.NumericTickProviderSpec generateYAxisSpec() {
    // ignore: omit_local_variable_types
    List<charts.TickSpec<double>> data = [];
    final _maxValue = (1.25 * maxValueY).floor().toInt();
    final inc = 0.1;
    for (var i = 0; i <= _maxValue; i++) {
      final value = inc * i * _maxValue;
      data += [charts.TickSpec<double>(value)];
    }
    return charts.StaticNumericTickProviderSpec(data);
  }

  Widget buildTimeLine() {
    final interval = bloc.generateViewportInterval(bids);
    return charts.TimeSeriesChart(
      generateData(),
      defaultRenderer: generateRender(),
      animate: false,
      dateTimeFactory: charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: generateYAxisSpec(),
        showAxisLine: true,
        renderSpec: charts.SmallTickRendererSpec(
            minimumPaddingBetweenLabelsPx: 0,
            labelRotation: 0,
            tickLengthPx: 10,
            labelOffsetFromTickPx: 0,
            labelOffsetFromAxisPx: 0,
            labelStyle: charts.TextStyleSpec(
              fontSize: bloc.axisYFontSize,
              color: style.axisFontColor,
            )),
      ),
      layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec: charts.MarginSpec.fixedPixel(0)),
      behaviors: [
        PanAndZoomControlBehavior(
            initialState: CommonPanControlBehaviourInitialState(0, 0, 0),
            panningCompletedCallback: () {},
            panningStartedCallback: () {},
            panningUpdateCallback: bloc.panningUpdateCallback),
      ],
      domainAxis: charts.EndPointsTimeAxisSpec(
        showAxisLine: true,
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: const charts.TimeFormatterSpec(
              format: 'dd:HH', transitionFormat: 'dd:HH'),
          hour: const charts.TimeFormatterSpec(
              format: 'HH:mm', transitionFormat: 'HH:mm'),
          minute: const charts.TimeFormatterSpec(
            format: 'mm:ss',
            transitionFormat: 'mm:ss',
          ),
        ),
        tickProviderSpec: generateXAxisSpec(),
        renderSpec: charts.SmallTickRendererSpec(
          minimumPaddingBetweenLabelsPx: 0,
          labelRotation: 90,
          tickLengthPx: bloc.tickLengthPx,
          labelJustification: charts.TickLabelJustification.inside,
          labelStyle: charts.TextStyleSpec(
              fontSize: bloc.axisXFontSize(bids.length),
              color: style.axisFontColor),
          lineStyle: charts.LineStyleSpec(
              color: style.axisLineColor, thickness: style.axisLineWidth),
        ),
        viewport: charts.DateTimeExtents(
          start: interval.start,
          end: interval.end,
        ),
      ),
    );
  }

  Widget buildStreamChart(final BuildContext context) {
    final rsize = bloc.viewportSize;
    return StreamBuilder(
      initialData: true,
      stream: bloc.intervalDidChangeStream,
      builder: (final BuildContext context, final AsyncSnapshot<bool> snp) {
        final viewport = Size(
            rsize.width - bloc.padding * 2, rsize.height - bloc.tickLengthPx);
        return Container(
          width: viewport.width,
          height: viewport.height,
          color: style.chartBackgroundColor,
          child: buildTimeLine(),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final rsize = bloc.viewportSize;
    return Container(
      width: rsize.width,
      height: rsize.height,
      child: Align(
        alignment: Alignment.topRight,
        child: buildStreamChart(context),
      ),
    );
  }

  charts.SeriesRendererConfig<DateTime> generateRender();
}
