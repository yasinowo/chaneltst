import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var isBlocked = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let screenRecordChannel = FlutterMethodChannel(name: "screen_record_channel",
                                              binaryMessenger: controller.binaryMessenger)

    screenRecordChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      switch call.method {
      case "toggleScreenRecording":
        self.isBlocked = !self.isBlocked
        result(self.isBlocked)
        // توجه: اپل اجازه مسدودسازی اسکرین رکوردینگ رو در سطح سیستم نمی‌ده، فقط یک حالت اعلامی است.
        break

      case "isScreenRecordingAllowed":
        result(!self.isBlocked)
        break

      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
