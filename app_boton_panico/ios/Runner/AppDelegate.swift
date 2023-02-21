import UIKit
import Flutter
import GoogleMaps
import background_locator_2

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    } 
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCfK3Fp-ScPOOhLGtTki7nejALoQXZs96o")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
