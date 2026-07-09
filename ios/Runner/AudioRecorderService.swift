import AVFoundation
import Foundation

final class AudioRecorderService: NSObject {
  private var recorder: AVAudioRecorder?
  private var currentURL: URL?

  func requestPermission(completion: @escaping (Bool) -> Void) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }

  func startRecording() throws -> String {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
    try session.setActive(true)

    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileName = "visit-\(Int(Date().timeIntervalSince1970)).wav"
    let url = documents.appendingPathComponent(fileName)

    let settings: [String: Any] = [
      AVFormatIDKey: kAudioFormatLinearPCM,
      AVSampleRateKey: 48000.0,
      AVNumberOfChannelsKey: 1,
      AVLinearPCMBitDepthKey: 16,
      AVLinearPCMIsFloatKey: false,
      AVLinearPCMIsBigEndianKey: false
    ]

    let recorder = try AVAudioRecorder(url: url, settings: settings)
    recorder.isMeteringEnabled = true
    recorder.record()

    self.recorder = recorder
    self.currentURL = url
    return url.path
  }

  func stopRecording() throws -> String {
    guard let recorder = recorder, let url = currentURL else {
      throw NSError(domain: "AudioRecorderService", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "No active recording."
      ])
    }

    recorder.stop()
    self.recorder = nil
    self.currentURL = nil
    try AVAudioSession.sharedInstance().setActive(false)
    return url.path
  }
}
