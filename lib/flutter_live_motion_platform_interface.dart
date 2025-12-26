import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_live_motion_method_channel.dart';

abstract class FlutterLiveMotionPlatform extends PlatformInterface {
  /// Constructs a FlutterLiveMotionPlatform.
  FlutterLiveMotionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLiveMotionPlatform _instance = MethodChannelFlutterLiveMotion();

  /// The default instance of [FlutterLiveMotionPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLiveMotion].
  static FlutterLiveMotionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLiveMotionPlatform] when
  /// they register themselves.
  static set instance(FlutterLiveMotionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Generates a Live Photo (iOS) or Motion Photo (Android).
  ///
  /// [imagePath] and [videoPath] are required.
  /// Returns a [dynamic] result:
  /// - iOS: [bool] indicating success (saved to Photos Library).
  /// - Android: [String] path to the generated Motion Photo file.
  Future<dynamic> generate({required String imagePath, required String videoPath}) {
    throw UnimplementedError('generate() has not been implemented.');
  }
}
