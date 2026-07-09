import 'package:flutter/services.dart';

class ShareService {
  static const _channel = MethodChannel('voice_assistant/share');

  Future<void> shareText(String text) async {
    await _channel.invokeMethod<void>('shareText', {'text': text});
  }
}
