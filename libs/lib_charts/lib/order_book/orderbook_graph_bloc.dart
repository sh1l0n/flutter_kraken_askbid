//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_charts module
//

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:lib_model/order.dart';

enum OrderBookSymbol {
  ETH_BTC,
  LTC_BTC,
}

class OrderBookGraphBloc {
  OrderBookGraphBloc(
      {@required this.padding,
      @required this.axisYFontSize,
      @required this.axisXFontMaxSize,
      @required this.tickLengthAxisY,
      @required this.tickMaxLengthAxisX});

  final _intervalDidChangeStreamController = StreamController<bool>.broadcast();
  Stream<bool> get intervalDidChangeStream =>
      _intervalDidChangeStreamController.stream;
  Sink<bool> get _intervalDidChangeSink =>
      _intervalDidChangeStreamController.sink;

  final int axisYFontSize;
  final int axisXFontMaxSize;

  int axisXFontSize(final int dataLength) {
    var size = axisXFontMaxSize / _scale;
    if (_ifFullScreen) {
      size = dataLength/axisXFontMaxSize;
    }
    return max(1, size.toInt());
  }

  Size _viewportSize = Size.zero;
  Size get viewportSize => _viewportSize;
  set viewportSize(final Size size) {
    _viewportSize = size;
  }

  final double padding;
  final int tickLengthAxisY;
  final int tickMaxLengthAxisX;
  int get tickLengthPx => tickMaxLengthAxisX ~/ _scale;

  // int maxYValue = 0;
  int _offset = 0;
  int _limit = 0;
  double _scale = 1;
  double _dx = 0;

  void reset() {
    _offset = 0;
    _limit = 0;
    _scale = 1;
    _dx = 0;
  }

  bool _ifFullScreen = false;
  bool get ifFullScreen => _ifFullScreen;
  void fullscreen(bool enable) {
    if (enable != _ifFullScreen) {
      _isAutoscroll = false;
      _ifFullScreen = enable;
      _refreshChart();
    }
  }

  bool _isAutoscroll = false;
  bool get isAutoscroll => _isAutoscroll;
  void autoscroll(bool enable) {
    if (_isAutoscroll != enable) {
      _ifFullScreen = false;
      _isAutoscroll = enable;
      _refreshChart();
    }
  }

  void panningUpdateCallback(final double sc, final double dx, bool isPanning) {
    final scale = 6 - sc;
    if (scale != 1 && !isPanning) {
      _scale = scale;
    }
    _dx = dx;
  }

  DateTimeInterval generateViewportInterval(final List<OrderWrapper> data) {
    var start = DateTime.now();
    var end = DateTime.now();

    if (!_ifFullScreen) {
      final _width = viewportSize.width - padding * 2;

      _limit = _width ~/ tickLengthPx;
      _limit = min(_limit, data.length - 1);

      if (data.isNotEmpty) {
        if (!_isAutoscroll) {
          final position = (_dx / tickLengthPx).abs();
          final positionMid = position.toInt().toDouble() + 0.5;

          var offset =
              position > positionMid ? position.toInt() + 1 : position.toInt();

          offset = max(0, min(offset, data.length - _limit));
          _offset = offset;
        } else {
          _offset = max(0, data.length - _limit);
        }

        final tstart = data[_offset].timestamp;
        final tend = data[_offset + _limit >= data.length
                ? data.length - 1
                : _offset + _limit]
            .timestamp;

        start = DateTime.fromMillisecondsSinceEpoch(tstart);
        end = DateTime.fromMillisecondsSinceEpoch(tend);
      }
    } else if (_ifFullScreen && data.isNotEmpty) {
      start = DateTime.fromMillisecondsSinceEpoch(data.first.timestamp);
      end = DateTime.fromMillisecondsSinceEpoch(data.last.timestamp);
    }

    return DateTimeInterval(start: start, end: end);
  }

  charts.DateTimeTickProviderSpec generateXAxisSpec(
      final List<OrderWrapper> data) {
    // ignore: omit_local_variable_types
    List<charts.TickSpec<DateTime>> timers = [];
    for (var i = 0; i < data.length; i++) {
      final serie = data[i];
      final time = DateTime.fromMillisecondsSinceEpoch(serie.timestamp);
      // final label = '$i';
      final label = '${time.hour}:${time.minute}:${time.second}';
      timers += [charts.TickSpec<DateTime>(time, label: label)];
    }
    return charts.StaticDateTimeTickProviderSpec(timers);
  }

  charts.NumericTickProviderSpec generateYAxisSpec(final double maxValue) {
    // ignore: omit_local_variable_types
    List<charts.TickSpec<double>> data = [];
    final _maxValue = (1.25*maxValue).floor().toInt();
    final inc = 0.1;
    for (var i = 0; i <= _maxValue; i++) {
      final value = inc * i * _maxValue;
      data += [charts.TickSpec<double>(value)];
    }
    return charts.StaticNumericTickProviderSpec(data);
  }

  void _refreshChart() {
    if (_intervalDidChangeSink != null &&
        _intervalDidChangeStreamController.hasListener) {
      _intervalDidChangeSink.add(true);
    }
  }

  void dispose() {
    _intervalDidChangeStreamController.close();
  }
}

class DateTimeInterval {
  DateTimeInterval({@required this.start, @required this.end});
  final DateTime start;
  final DateTime end;
}
