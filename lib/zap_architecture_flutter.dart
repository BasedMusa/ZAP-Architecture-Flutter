library zap_architecture_flutter;

import 'package:package_info/package_info.dart';
import 'package:zap_architecture_flutter/src/globals.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

export 'src/size_config.dart';
export 'src/platforms_mixin.dart';
export 'src/status_mixin.dart';
export 'src/process_mixin.dart';
export 'src/http_mixin.dart';
export 'src/globals.dart';

/// Initialises PackageInfo content.
Future<void> init() async {
  packageInfo = await PackageInfo.fromPlatform();
}
