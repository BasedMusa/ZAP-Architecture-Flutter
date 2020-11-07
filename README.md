# ZAP Architecture (Flutter)

This helps you make Flutter apps way faster.
Provides useful utilities to make fast, responsive, and reliable apps.
Built on top of the zap_architecture plugin.
Handles boilerplate for integrating

## Using: PlatformsMixin

PlatformsMixin is a small utility mixin which lets you check if the app is being run on Android or iOS.
This is added to a Widget and then it's provided values can be used anywhere within that widget.

### Use inside StatelessWidget

```dart
import 'package:flutter/material.dart';
import 'package:zap_architecture_flutter/zap_architecture_flutter.dart';

class MyWidget extends StatelessWidget with PlatformsMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("App is running in iOS: $isIOS"), //App is running in iOS: true / false
        Text("App is running in Android: $isAndroid"), //App is running in Android: true / false
      ],
    );
  }
}
```

### Use inside StatefulWidget

```dart
import 'package:flutter/material.dart';
import 'package:zap_architecture_flutter/zap_architecture_flutter.dart';

class MyWidget extends StatefulWidget with PlatformsMixin {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {

    print("App is running in iOS" + widget.isIOS.toString());
    print("App is running in Android" + widget.isAndroid.toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("App is running in iOS: ${widget.isIOS}"), // App is running in iOS: true / false
        Text("App is running in Android: ${widget.isAndroid}"), // App is running in Android: true / false
      ],
    );
  }
}
```