import UIKit
import Flutter
import flutter_background_service_ios //new added for bg
import GoogleMaps //new added for maps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier" //new add for bg

    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyDYU25DhbGmJ7P7mdblVrqQjI12e2NPBJY")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
