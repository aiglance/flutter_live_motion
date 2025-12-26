
import 'flutter_live_motion_platform_interface.dart';

class FlutterLiveMotion {
  Future<String?> getPlatformVersion() {
    return FlutterLiveMotionPlatform.instance.getPlatformVersion();
  }

  /// Generates a Live Photo (iOS) or Motion Photo (Android).
  ///
  /// [imagePath] and [videoPath] are required.
  /// 
  /// Returns:
  /// - iOS: [bool] true if successfully saved to Photos Library.
  /// - Android: [String] path to the generated Motion Photo file (saved in cache directory).
  Future<dynamic> generate({required String imagePath, required String videoPath}) {
    return FlutterLiveMotionPlatform.instance.generate(imagePath: imagePath, videoPath: videoPath);
  }
}
