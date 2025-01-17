# Flutter Kraken bids/aks charts

Simple app which displays the amount of the first bid and ask order each 2 seconds interval as minimun (depends the network).

The orderbook is retrieved from the public endpoints of the [Kraken Exchange](https://www.kraken.com/)

Using [Google Charts](https://github.com/google/charts) for displaying data.

<p align="center">
<img src="doc/images/lines_screenshot.jpg" width="45%"/> 
<img  src="doc/images/bars_screenshot.jpg" width="45%"/> 
</p>

## Main Features

- Line and Bars charts.
- "Real time chart" (using GET requests instead WebSockets).
- Chart scrolling.
- Early version of chart zooming.
- Full screen view of the charts.
- Follow updated (Last) with custom user zooming.
- The data is saved in client using a [SQL database](https://github.com/tekartik/sqflite).
- The data is available for the whole app.
- Use Cache memory for quickly accessing.
- The data is cleared before every run action. 
- Detects network connection error.
- HTTP request feedback to the user.
- Unit testing HTTP requests.
- Route navigation between screens
- State managment, run/stop shared between screens (saved until app closed).
- State managment, full/last depends of the current displayed screen (saved until app closed).
- Integration testing MySQL database.
- HTTP Server working as middleware between client and Kraken.

Also there are some knowed [issues](https://github.com/sh1l0n/flutter_kraken_askbid/issues)

## Getting started

In order to run the app, you need to follow the next steps

1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install)

2. Clone and navigate to project root folder
```
git clone -b master git@github.com:sh1l0n/flutter_kraken_askbid.git
cd flutter_kraken_askbid/
```

3. Get flutter packages
```
chmod +x update.sh
./update.sh
```

4. First run the server
```
dart lib/server.dart
```

5. Set your server IP into [**libs/lib_requests/lib.server_api.dart**](https://github.com/sh1l0n/flutter_kraken_askbid/blob/master/libs/lib_requests/lib/server_api.dart)

```
Line 23: String get apiUrl => 'http://192.168.1.7:4040';
```

6. Run client
```
flutter run lib/main.dart
```

## Testing

### Kraken api get orders api
```
flutter test test/kraken_api_test.dart
```

### Database test
```
flutter drive --driver integration_test/driver.dart --target integration_test/database_test.dart
```

## Licensed
GPLv3