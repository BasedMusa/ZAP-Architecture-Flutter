import 'package:flutter/material.dart';
import 'package:zap_architecture/zap_architecture.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

/// This handles the boilerplate for adding [Process] to a [ChangeNotifier].
/// Use that [ChangeNotifier] with [Provider] to make the [Status] variable
/// available anywhere in your app.
///
/// Also lets you utilise
/// [Process.onProcessSuccess] and [Process.onProcessFailed] callback which
/// otherwise can't be used.
///
/// For example:
///
/// 1. Wrap [MaterialApp] inside [MultiProvider] and then pass your
/// [ChangeNotifier] in [MultiProvider].
///
/// 2. Use [Consumer] widget (comes with 'provider' package) to get that
/// [ChangeNotifier].
///
/// 3. Access the [process] variable from that [ChangeNotifier] and then decide
/// show a loading indicator and error dialogs.
mixin ProcessMixin on ChangeNotifier {
  /// Private variable which actually holds the [Process] class.
  ///
  /// This is private so that a new setter can be defined to override the
  /// default functionality when assigning a new value to this variable.
  ///
  /// The getter is an mandatory when you override the setter.
  Process _process = Process.clear();

  /// Exposes the private [_process] variable for reading purposes.
  Process get process => _process;

  /// Updates value of process variable and notifies listeners of the
  /// [ChangeNotifier].
  ///
  /// If using Provider, this will rebuild your UI wherever you use [Consumer]
  /// and [Selector] widgets.
  ///
  /// Additionally, calls the [Process.onProcessFailed] and
  /// [Process.onProcessFailed] if process is stopping and the callbacks are
  /// provided.
  set process(Process process) {
    // Checks if an ongoing process is being stopped.
    // Then executes further code.
    if (process.working == false && _process.working == true) {
      // If an error occurred in the process, and if the
      // [Process.onProcessFailed] was provided then that is called.
      if (_process.onProcessFailed != null && process.error == true)
        _process.onProcessFailed?.call();

      // If the process was completed successfully, and if the
      // [Process.onProcessSuccess] was provided then that is called.
      if (_process.onProcessSuccess != null && process.error == false)
        _process.onProcessSuccess?.call();
    }

    // Assigning value to the private variable.
    _process = process;

    // Notifies listeners.
    // In the 'Provider' plugin, this rebuilds the UI if it is being called by
    // a [Consumer] or [Selector] widget.
    notifyListeners();
  }
}
