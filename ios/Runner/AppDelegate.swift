import UIKit
import Flutter
import Firebase
import FacebookCore

// COMPLETE: Import google_mobile_ads
// import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
      ApplicationDelegate.shared.application(
          app,
          open: url,
          sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
          annotation: options[UIApplication.OpenURLOptionsKey.annotation]
      )
  } 
}