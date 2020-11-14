import 'package:flutter/material.dart';
import 'package:zap_architecture_flutter/src/helpers.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

class SizeConfig {
  double _deviceHeight;
  double _deviceWidth;
  double _textScale;
  EdgeInsets _safeArea;
  DeviceScreenType _screenType;

  SizeConfig._internal(this._deviceHeight, this._deviceWidth, this._textScale,
      this._safeArea, this._screenType);

  static SizeConfig init(context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    final double deviceHeight = mediaQuery.size.height;
    final double deviceWidth = mediaQuery.size.width;
    final double textScale = mediaQuery.textScaleFactor;
    final EdgeInsets safeArea = mediaQuery.padding;
    final DeviceScreenType screenType = getDeviceType(mediaQuery.size);

    return SizeConfig._internal(
        deviceHeight, deviceWidth, textScale, safeArea, screenType);
  }

  double text(double size) {
    assert(_textScale != null);
    return _textScale * size;
  }

  double height(double size) {
    assert(_deviceHeight != null);
    return _deviceHeight * size;
  }

  double width(double size) {
    assert(_deviceWidth != null);
    return _deviceWidth * size;
  }

  EdgeInsets get safeArea => this._safeArea;

  bool get isDesktopScreen => _screenType == DeviceScreenType.desktop;
  bool get isTabletScreen => _screenType == DeviceScreenType.tablet;
  bool get isMobileScreen => _screenType == DeviceScreenType.mobile;
}
