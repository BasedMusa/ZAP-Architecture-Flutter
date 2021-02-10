import 'package:get/get.dart';
import 'package:zap_architecture/zap_architecture.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

/// This handles the boilerplate for adding [Status] to a [GetxController].
/// Use that [GetxController] to make the [Status] variable
/// available anywhere in your app.
mixin StatusMixin on GetxController {
  /// Private variable which actually holds the [Status] variable.
  ///
  /// This is private so that a new setter can be defined to override the
  /// default functionality when assigning a new value to this variable.
  ///
  /// The getter is a mandatory when you override the setter.
  Status _status = Status.clear();

  /// Exposes the private [_process] variable.
  Status get status => _status;

  /// Updates value of [_status] variable and updates the [GetxController] and
  /// rebuilds your UI.
  set status(Status status) {
    // Assigning value to the private variable.
    _status = status;

    // Rebuilds your UI wherever [GetBuilder] is being used.
    update();
  }
}
