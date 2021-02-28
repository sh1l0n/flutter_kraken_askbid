// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_charts module
//
// TODO: Check licenses

import 'package:charts_common/common.dart' as common
    show ChartBehavior, PanningCompletedCallback;
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart' show immutable;
import 'package:charts_flutter/src/behaviors/chart_behavior.dart';
import 'package:charts_flutter/src/base_chart_state.dart';
import 'common_pan_control_behaviour.dart';
import 'common_pan_zoom_behaviour.dart';
import 'pan_control_behaviour.dart';

@immutable
class PanAndZoomControlBehavior
    extends ChartBehavior<CommonPanAndZoomBehavior> {
  final _desiredGestures = new Set<GestureType>.from([
    GestureType.onDrag,
  ]);

  Set<GestureType> get desiredGestures => _desiredGestures;

  /// Optional callback that is called when pan / zoom is completed.
  ///
  /// When flinging this callback is called after the fling is completed.
  /// This is because panning is only completed when the flinging stops.
  final common.PanningCompletedCallback panningCompletedCallback;
  final PanningStartedCallback panningStartedCallback;
  final PanningUpdateallback panningUpdateCallback;
  final CommonPanControlBehaviourInitialState initialState;

  PanAndZoomControlBehavior(
      {@required this.initialState,
      this.panningCompletedCallback,
      this.panningStartedCallback,
      this.panningUpdateCallback});

  @override
  CommonPanAndZoomBehavior createCommonBehavior<D>() {
    return FlutterPanAndZoomControlBehavior<D>(initialState)
      ..panningCompletedCallback = panningCompletedCallback
      ..panningStartedCallback = panningStartedCallback
      ..panningUpdateCallback = panningUpdateCallback;
  }

  @override
  void updateCommonBehavior(common.ChartBehavior commonBehavior) {}

  @override
  String get role => 'PanAndZoom';

  bool operator ==(Object other) {
    return other is PanAndZoomControlBehavior &&
        other.panningCompletedCallback == panningCompletedCallback &&
        other.panningStartedCallback == panningStartedCallback &&
        other.panningUpdateCallback == panningUpdateCallback;
  }

  int get hashCode {
    return panningCompletedCallback.hashCode;
  }
}

/// Adds fling gesture support to [common.PanAndZoomBehavior], by way of
/// [FlutterPanBehaviorMixin].
class FlutterPanAndZoomControlBehavior<D> extends CommonPanAndZoomBehavior<D>
    with FlutterPanControlBehaviorMixin {
  FlutterPanAndZoomControlBehavior(
      final CommonPanControlBehaviourInitialState initialState)
      : super(initialState);
}
