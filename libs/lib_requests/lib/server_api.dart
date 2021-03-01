//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_requests package
//

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lib_model/order_book_update.dart';

class ServerApi {
  static final ServerApi _singleton = ServerApi._internal();
  factory ServerApi() {
    return _singleton;
  }

  ServerApi._internal();
  
  String get apiUrl => 'http://192.168.1.7:4040';

  Map<String, String> get headers =>
    {'content-type': 'application/json; charset=utf-8'};

  Future<OrderBookUpdateWrapper> getBooks() async {

    var completer = Completer<OrderBookUpdateWrapper>();
     
    try {
      final response = await http.get(apiUrl, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final update = OrderBookUpdateWrapper.fromMap(jsonData);
        print('update: $update');
        completer.complete(update);
      } else {
        completer.complete(null);
      }
    } catch(e) {
      completer.complete(null);
    }
    return completer.future;
  }


}