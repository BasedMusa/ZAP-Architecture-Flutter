import 'package:flutter/material.dart';
import 'package:zap_architecture/zap_architecture.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

/// This handles the boilerplate for adding [Status] to a [ChangeNotifier].
/// Use that [ChangeNotifier] with [Provider] to make the [Status] variable
/// available anywhere in your app.
///
/// For example:
///
/// 1. Wrap [MaterialApp] inside [MultiProvider] and then pass your
/// [ChangeNotifier] in [MultiProvider].
///
/// 2. Use [Consumer] widget (comes with 'provider' package) to get that
/// [ChangeNotifier].
///
/// 3. Access the [status] variable from that [ChangeNotifier] and then decide
/// if the app should show a loading indicator or an error page or show the
/// loaded data.
mixin StatusMixin on ChangeNotifier {
  Status _status = Status.clear();

  Status get status => _status;

  set status(Status taskStatus) {
    _status = taskStatus;
    notifyListeners();
  }
}
