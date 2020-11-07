import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

/// Provides booleans anywhere within a widget to check the operating system.
/// This helps you quickly develop platform-aware designs and widgets.
///
/// Example Usage:
///
/// 1. Add this to your Stateful/Stateless widget like so:
///   class MyStatelessPage extends StatelessWidget with PlatformsMixin {..}
///   OR
///   class MyStatelessPage extends StatefulWidget with PlatformsMixin {..}
///
/// 2. Use this anywhere inside that widget to access the boolean values:
///   [Stateless Widget]: 'isIOS' OR 'isAndroid'.
///   [Stateful Widget]: 'widget.isIOS' OR 'widget.isAndroid'.
///
/// 3. Use in IF statements to decide if to show Android UI or iOS UI. Example:
///       ....
///           Container(
///             child: widget.isIOS ? CupertinoButton(..) : RaisedButton(..)
///           )
///       ....
mixin PlatformsMixin on Widget {
  /// Lets you check if app is running on iOS.
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  /// Lets you check if app is running on Android.
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
}

/// Forces a class to implement a onErrorTap callback which can be universally
/// called by all your error pages.
///
/// I recommend using this with your data models.
abstract class ErrorSafeBLOC {
  VoidCallback get onErrorTap;
}

