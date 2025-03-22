import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // استدعاء تهيئة Firebase هنا
    FirebaseApp.configure()

    // تسجيل البلغِنات (Plugins)
    GeneratedPluginRegistrant.register(with: self)

    // أكمل التهيئة الافتراضية
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
