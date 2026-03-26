import 'package:flutter/foundation.dart';

class AppEnv {
  AppEnv._();

  /// Android emulator: http://10.0.2.2:3000
  /// iOS simulator: http://localhost:3000
  /// Web/desktop: http://localhost:3000
  /// Physical device: use your machine IP (e.g. http://192.168.x.x:3000)
  static String get mockApiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://localhost:3000';
      case TargetPlatform.fuchsia:
        return 'http://localhost:3000';
    }
  }
}
