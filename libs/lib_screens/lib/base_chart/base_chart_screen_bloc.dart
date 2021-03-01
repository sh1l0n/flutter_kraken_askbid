//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'dart:async';

import 'package:lib_ddbb/cache/kraken_cache.dart';
import 'package:lib_ddbb/storage/exchange.dart';
import 'package:lib_model/order.dart';
import 'package:lib_requests/server_api.dart';

class BaseChartScreenBLoC {
  final _updateBooksController = StreamController<bool>.broadcast();
  Stream<bool> get updateBookStream => _updateBooksController.stream;
  Sink<bool> get _updateBookSink => _updateBooksController.sink;

  final _changeStateStreamController = StreamController<bool>.broadcast();
  Stream<bool> get changeStateStream => _changeStateStreamController.stream;
  Sink<bool> get _changeStateSink => _changeStateStreamController.sink;

  final _networkErrorStreamController = StreamController<bool>.broadcast();
  Stream<bool> get networkErrorStream => _networkErrorStreamController.stream;
  Sink<bool> get _networkErrorSink => _networkErrorStreamController.sink;

  final _gettingServerDataStreamController = StreamController<bool>.broadcast();
  Stream<bool> get gettingServerDataStream =>
      _gettingServerDataStreamController.stream;
  Sink<bool> get _gettingServerDataSink =>
      _gettingServerDataStreamController.sink;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  bool _isAutoscrolling = false;
  bool get isAutoscrolling => _isAutoscrolling;

  bool _isFullcreen = false;
  bool get isFullcreen => _isFullcreen;

  bool _isGettinServerData = false;
  bool get isGettinServerData => _isGettinServerData;

  Duration get refreshingTimeout => Duration(milliseconds: 2000);

  String get exchangeName => 'kraken';

  Future<void> _updateOrderBook() async {
    _notifyServerUpdating(true);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final update = await ServerApi().getBooks();
    if( update != null) {
      final bid = OrderWrapper(update.bid.price, update.bid.amount, timestamp);
      final ask = OrderWrapper(update.ask.price, update.ask.amount, timestamp);

      await ExchangeWrapperProvider.update(exchangeName, bid, ask);
      KrakenMemoryCache().update(bid: bid, ask: ask);
    } else {
      _notifyNetworkError();
    }
    _notifyServerUpdating(false);
  }

  Future<void> _refreshData() async {
    if (_isRunning) {
      await _updateOrderBook();
      _notifyDidUpdateBooks();
      Future.delayed(refreshingTimeout, () {
        _refreshData();
      });
    }
  }

  Future<void> run() async {
    if (!_isRunning) {
      _isRunning = true;
      _notifyDidChangeState();
      await KrakenMemoryCache().clean();
      _notifyDidUpdateBooks();
      // ignore: unawaited_futures
      _refreshData();
    }
  }

  void _notifyDidChangeState() {
    if (_changeStateStreamController.hasListener && _changeStateSink != null) {
      _changeStateSink.add(true);
    }
  }

  void _notifyDidUpdateBooks() {
    if (_updateBooksController.hasListener && _updateBookSink != null) {
      _updateBookSink.add(true);
    }
  }

  void _notifyServerUpdating(final bool update) {
    if (_gettingServerDataStreamController.hasListener &&
        _gettingServerDataSink != null) {
      _isGettinServerData = update;
      _gettingServerDataSink.add(update);
    }
  }

    void _notifyNetworkError() {
    if (_networkErrorStreamController.hasListener &&
        _networkErrorSink != null) {
      _networkErrorSink.add(true);
    }
  }

  void pause() {
    if (_isRunning) {
      _isRunning = false;
      _notifyDidChangeState();
    }
  }

  void fullscreen(bool willFullscreen) async {
    _isFullcreen = willFullscreen;
    _isAutoscrolling = false;
    _notifyDidChangeState();
  }

  void autoscroll(bool willAutoscroll) {
    _isAutoscrolling = willAutoscroll;
    _isFullcreen = false;
    _notifyDidChangeState();
  }

  void dispose() {
    _changeStateStreamController.close();
    _updateBooksController.close();
    _gettingServerDataStreamController.close();
    _networkErrorStreamController.close();
  }
}
