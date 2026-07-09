import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let audioRecorderService = AudioRecorderService()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let audioChannel = FlutterMethodChannel(
      name: "voice_assistant/audio_recorder",
      binaryMessenger: controller.binaryMessenger
    )
    let shareChannel = FlutterMethodChannel(
      name: "voice_assistant/share",
      binaryMessenger: controller.binaryMessenger
    )

    audioChannel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "requestPermission":
        self.audioRecorderService.requestPermission { granted in
          result(granted)
        }
      case "startRecording":
        do {
          result(try self.audioRecorderService.startRecording())
        } catch {
          result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
        }
      case "stopRecording":
        do {
          result(try self.audioRecorderService.stopRecording())
        } catch {
          result(FlutterError(code: "STOP_FAILED", message: error.localizedDescription, details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    shareChannel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "shareText":
        guard
          let args = call.arguments as? [String: Any],
          let text = args["text"] as? String
        else {
          result(FlutterError(code: "BAD_ARGS", message: "Missing text.", details: nil))
          return
        }
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.window?.rootViewController?.present(activity, animated: true) {
          result(nil)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
