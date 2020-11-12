import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _defaultDesktopBreakpoint = 950;
const double _defaultTabletBreakpoint = 600;
const double _defaultWatchBreakpoint = 300;

enum DeviceScreenType { mobile, tablet, desktop, watch }

/// Returns the [DeviceScreenType] that the application is currently running on
DeviceScreenType getDeviceType(Size size) {
  double deviceWidth = size.shortestSide;

  if (kIsWeb) {
    deviceWidth = size.width;
  }

  if (deviceWidth >= _defaultDesktopBreakpoint) {
    return DeviceScreenType.desktop;
  }

  if (deviceWidth >= _defaultTabletBreakpoint) {
    return DeviceScreenType.tablet;
  }

  if (deviceWidth < _defaultWatchBreakpoint) {
    return DeviceScreenType.watch;
  }

  return DeviceScreenType.mobile;
}