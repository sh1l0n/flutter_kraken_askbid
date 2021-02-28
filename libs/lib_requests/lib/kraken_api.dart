//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_requests package
//

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:lib_model/order.dart';
import 'package:lib_model/order_book_update.dart';

// array of array entries(<time>, <open>, <high>, <low>, <close>, <vwap>, <volume>, <count>)
class OHCLDataWrapper {
  const OHCLDataWrapper(this.timestamp, this.open, this.high, this.low,
      this.close, this.vwap, this.volume, this.count);
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double vwap;
  final double volume;
  final int count;
  Map<String, dynamic> toJson() => {
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'vwap': vwap,
        'volume': volume,
        'count': count
      };

  static OHCLDataWrapper fromJson(final List data) {
    final timestamp = data[0] as int;
    final open = data[1] as String;
    final high = data[2] as String;
    final low = data[3] as String;
    final close = data[4] as String;
    final vwap = data[5] as String;
    final volume = data[6] as String;
    final count = data[7] as int;

    return OHCLDataWrapper(
        timestamp,
        int.tryParse(open) ?? 0,
        int.tryParse(high) ?? 0,
        int.tryParse(low) ?? 0,
        int.tryParse(close) ?? 0,
        int.tryParse(vwap) ?? 0,
        int.tryParse(volume) ?? 0,
        count);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class KrakenApiWrapper {
  const KrakenApiWrapper(this.secret, this.public);
  final String secret;
  final String public;
  Map<String, dynamic> toJson() => {'secret': secret, 'public': public};

  static KrakenApiWrapper fromJson(final Map<String, dynamic> data) {
    final publicKey = data['apiKey'];
    final privateKey = data['secretKey'];
    return KrakenApiWrapper(privateKey, publicKey);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

enum KrakenAssetPair { xbtusd, xbteth }

class KrakenApi {
  static final KrakenApi _singleton = KrakenApi._internal();
  factory KrakenApi() {
    return _singleton;
  }

  KrakenApi._internal();
  
  String get apiUrl => 'https://api.kraken.com/0/';

  Map<String, String> get headers =>
      {'content-type': 'application/json; charset=utf-8'};

  int generateNone() {
    return (DateTime.now().microsecondsSinceEpoch * 1000);
  }

  Future<String> getHash(final KrakenApiWrapper env, final String nonce) async {
    var completer = Completer<String>();
    final hash = await md5
        .convert(utf8.encode(nonce + env.secret + env.public))
        .toString();
    completer.complete(hash);
    return completer.future;
  }

  // interval = time frame interval in minutes (optional):
  // 1 (default), 5, 15, 30, 60, 240, 1440, 10080, 21600
  //  https://api.kraken.com/0/public/OHLC?pair=xbtusd&interval=15
  Future<List<OHCLDataWrapper>> getOHLC(
      final KrakenAssetPair assetPair, final int interval) async {
    var completer = Completer<List<OHCLDataWrapper>>();
    final path = 'public/OHLC';
    String pair;
    // ignore: omit_local_variable_types
    List<OHCLDataWrapper> values = [];

    switch (assetPair) {
      case KrakenAssetPair.xbtusd:
        pair = 'xbtusd';
        break;
      default:
        pair = 'xbtusd';
        break;
    }
    final url = apiUrl + path + '?pair=$pair&interval=$interval';

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['result'] as Map<String, dynamic>;
        final rasset = data.keys.first;
        for (final ohlc in data[rasset]) {
          values += [OHCLDataWrapper.fromJson(ohlc)];
        }
      }
      // ignore: empty_catches
    } catch (e) {}

    completer.complete(values);
    return completer.future;
  }

  Future<OrderBookUpdateWrapper> getBooks(
      final KrakenAssetPair assetPair, final int count) async {
    final path = 'public/Depth';

    var completer = Completer<OrderBookUpdateWrapper>();

    String pair;
    switch (assetPair) {
      case KrakenAssetPair.xbtusd:
        pair = 'xbtusd';
        break;
      default:
        pair = 'xbtusd';
        break;
    }
    final url = apiUrl + path + '?pair=$pair&count=$count';

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final books = jsonData['result'] as Map<String, dynamic>;
        final rasset = books.keys.first;
        final rdata = books[rasset] as Map<String, dynamic>;
        final bids = rdata['bids'] as List;
        final asks = rdata['asks'] as List;

        final bid = OrderWrapper.fromJson(bids.first);
        final ask = OrderWrapper.fromJson(asks.first);
        final update = OrderBookUpdateWrapper(bid, ask);
        completer.complete(update);
      } else {
        completer.complete(null);
      }
    } catch (e) {
      completer.complete(null);
    }
    return completer.future;
  }
}
