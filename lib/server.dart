//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of Flutter-Kraken project
//

import 'dart:io';

import 'package:lib_requests/kraken_api.dart';

void main() async {
  
  final server = await HttpServer.bind('0.0.0.0', 4040);
  print('Listening on localhost:${server.port}');

  server.defaultResponseHeaders.add('content-type', 'application/json');

  await for (HttpRequest request in server) {
    print('[+] Client request');
    final book = await KrakenApi().getBooks(KrakenAssetPair.xbtusd, 1);  
    request.response.write(book.toString());
    await request.response.close();
  }
}
