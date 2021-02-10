import 'package:get/get.dart';
import 'package:zap_architecture/zap_architecture.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

/// This handles the boilerplate for adding [Process] to a [GetxController].
/// Use that [GetxController] to make the [Status] variable
/// available anywhere in your app.
mixin ProcessMixin on GetxController {
  /// Private variable which actually holds the [Process] variable.
  ///
  /// This is private so that a new setter can be defined to override the
  /// default functionality when assigning a new value to this variable.
  ///
  /// The getter is a mandatory when you override the setter.
  Process _process = Process.clear();

  /// Exposes the private [_process] variable.
  Process get process => _process;

  /// Updates value of [_process] variable and updates the [GetxController] and
  /// rebuilds your UI.
  set process(Process process) {
    // Assigning value to the private variable.
    _process = process;

    // Rebuilds your UI wherever [GetBuilder] is being used.
    update();
  }
}
