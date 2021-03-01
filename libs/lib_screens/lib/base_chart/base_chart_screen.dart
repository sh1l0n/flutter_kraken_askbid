//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:lib_bottom_bar/bottom_bar_bloc.dart';
import 'package:lib_charts/order_book/orderbook_graph_bloc.dart';
import 'package:lib_charts/order_book/orderbook_graph.dart';

import '../base_screen.dart';
import 'base_chart_screen_bloc.dart';

class BaseChartScreen extends BaseScreen {
  const BaseChartScreen(
      {@required final CustomBottomBarBLoC bottomBarBloc,
      @required this.orderBookBloc,
      @required this.chartScreenBloc})
      : super(bottomBarBloc: bottomBarBloc);

  final OrderBookGraphBloc orderBookBloc;
  final BaseChartScreenBLoC chartScreenBloc;

  @override
  State<StatefulWidget> createState() => BaseChartScreenState();
}

class BaseChartScreenState extends BaseScreenState {
  OrderBookGraphBloc get bloc => (widget as BaseChartScreen).orderBookBloc;

  BaseChartScreenBLoC get chartScreenBloc =>
      (widget as BaseChartScreen).chartScreenBloc;


  @override
  void initState() {
    super.initState();
    chartScreenBloc.networkErrorStream.listen((event) { 
      buildSnackbar();
    });
  }

  void buildSnackbar() {
    chartScreenBloc.pause();
    final snackBar = SnackBar(
      content: Text('Ups! Cannot get data from server'),
      action: SnackBarAction(
        label: 'Try again?',
        onPressed: () {
          chartScreenBloc.run();
          // Some code to undo the change.
        },
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget buildButton(
      final Function onPressed, final IconData iconCode, final String text,
      {bool highlighted = false}) {
    final size = Size(160, 60);

    final _wcolor = onPressed != null ? Color(0xffefefef) : Color(0xffbdbdbd);
    final wcolor = highlighted ? Color(0xffcddc39) : _wcolor;

    return Container(
      width: size.width,
      height: size.height,
      color: onPressed != null ? Color(0xff424242) : Color(0xff848484),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(iconCode, color: wcolor),
        label: Text(
          text,
          key: Key('appBarTitleKey'),
          style: TextStyle(
              color: wcolor,
              fontSize: size.height * 0.4,
              fontWeight: FontWeight.w400,
              fontFamily: 'Monserrat',
              package: 'lib_assets'),
        ),
      ),
    );
  }

  Widget buildButtonGrid(final OrderBookGraphBloc bloc) {
    return StreamBuilder(
        initialData: true,
        stream: chartScreenBloc.changeStateStream,
        builder: (final BuildContext c, final AsyncSnapshot<bool> snp) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(
                      chartScreenBloc.isRunning
                          ? null
                          : () {
                              chartScreenBloc.run();
                            },
                      chartScreenBloc.isRunning
                          ? Icons.connect_without_contact
                          : Icons.run_circle,
                      chartScreenBloc.isRunning ? 'Running' : 'Run',
                      highlighted: chartScreenBloc.isRunning),
                  buildButton(
                      !chartScreenBloc.isRunning
                          ? null
                          : () {
                              chartScreenBloc.pause();
                            },
                      Icons.stop,
                      'Stop'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(() {
                    bloc.fullscreen(!bloc.ifFullScreen);
                    chartScreenBloc.fullscreen(bloc.ifFullScreen);
                  }, Icons.fullscreen, 'Full', highlighted: bloc.ifFullScreen),
                  buildButton(() {
                    bloc.autoscroll(!bloc.isAutoscroll);
                    chartScreenBloc.autoscroll(bloc.isAutoscroll);
                  }, Icons.last_page, 'Last', highlighted: bloc.isAutoscroll),
                ],
              ),
            ],
          );
        });
  }

  Widget buildLegenItem(final Color color, final String text) {
    return Row(
      children: [
        Container(width: 30, height: 2, color: color),
        Container(width: 5),
        Text(text,
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff343434),
                fontWeight: FontWeight.w400,
                fontFamily: 'Monserrat',
                package: 'lib_assets')),
      ],
    );
  }

  Widget buildLegend(final OrderBookGraphBloc bloc) {
    return Container(
      width: 300,
      height: 30,
      color: Color(0x44ffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildLegenItem(Colors.pink, 'ask'),
          StreamBuilder(
            initialData: chartScreenBloc.isGettinServerData,
            stream: chartScreenBloc.gettingServerDataStream,
            builder:
                (final BuildContext context, final AsyncSnapshot<bool> snp) {
              return Container(
                width: 20,
                height: 20,
                child: snp.data
                    ? CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Color(0xff8a8a8a),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff424242)),
                      )
                    : null,
              );
            },
          ),
          buildLegenItem(Colors.lime, 'bid'),
        ],
      ),
    );
  }

  @override
  Widget buildBody(final BuildContext context, final Size size) {
    final viewportSize = Size(size.width * 0.9, size.height * 0.5);
    (widget as BaseChartScreen).orderBookBloc.viewportSize = viewportSize;

    final title =
        widget.bottomBarBloc.categories[widget.bottomBarBloc.selected].title;

    return Container(
      width: size.width,
      height: size.height,
      color: Color(0xff747474),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              'KRAKEN ${title.toUpperCase()}: ASK & BID BTC/USD 1st ORDER AMOUNT',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 25,
                  color: Color(0xffefefef),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Monserrat',
                  package: 'lib_assets'),
            ),
          ),
          Container(height: 20),
          Center(child: buildLegend(bloc)),
          Container(height: 10),
          Align(
              alignment: Alignment(0, 1),
              child: RepaintBoundary(
                child: StreamBuilder(
                  stream: chartScreenBloc.updateBookStream,
                  builder: (final BuildContext context,
                      final AsyncSnapshot<bool> snp) {
                    return generateGraph();
                  },
                ),
              )),
          Container(height: 40),
          Center(
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.2,
              child: buildButtonGrid(bloc),
            ),
          ),
        ],
      ),
    );
  }

  OrderBookGraph generateGraph() {
    return null;
  }
}
