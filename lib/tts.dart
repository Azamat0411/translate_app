import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef ErrorHandler = void Function(dynamic message);
typedef ProgressHandler = void Function(
    String text, int start, int end, String word);

const String iosAudioCategoryOptionsKey = 'iosAudioCategoryOptionsKey';
const String iosAudioCategoryKey = 'iosAudioCategoryKey';
const String iosAudioModeKey = 'iosAudioModeKey';
const String iosAudioCategoryAmbientSolo = 'iosAudioCategoryAmbientSolo';
const String iosAudioCategoryAmbient = 'iosAudioCategoryAmbient';
const String iosAudioCategoryPlayback = 'iosAudioCategoryPlayback';
const String iosAudioCategoryPlaybackAndRecord =
    'iosAudioCategoryPlaybackAndRecord';

const String iosAudioCategoryOptionsMixWithOthers =
    'iosAudioCategoryOptionsMixWithOthers';
const String iosAudioCategoryOptionsDuckOthers =
    'iosAudioCategoryOptionsDuckOthers';
const String iosAudioCategoryOptionsInterruptSpokenAudioAndMixWithOthers =
    'iosAudioCategoryOptionsInterruptSpokenAudioAndMixWithOthers';
const String iosAudioCategoryOptionsAllowBluetooth =
    'iosAudioCategoryOptionsAllowBluetooth';
const String iosAudioCategoryOptionsAllowBluetoothA2DP =
    'iosAudioCategoryOptionsAllowBluetoothA2DP';
const String iosAudioCategoryOptionsAllowAirPlay =
    'iosAudioCategoryOptionsAllowAirPlay';
const String iosAudioCategoryOptionsDefaultToSpeaker =
    'iosAudioCategoryOptionsDefaultToSpeaker';

const String iosAudioModeDefault = 'iosAudioModeDefault';
const String iosAudioModeGameChat = 'iosAudioModeGameChat';
const String iosAudioModeMeasurement = 'iosAudioModeMeasurement';
const String iosAudioModeMoviePlayback = 'iosAudioModeMoviePlayback';
const String iosAudioModeSpokenAudio = 'iosAudioModeSpokenAudio';
const String iosAudioModeVideoChat = 'iosAudioModeVideoChat';
const String iosAudioModeVideoRecording = 'iosAudioModeVideoRecording';
const String iosAudioModeVoiceChat = 'iosAudioModeVoiceChat';
const String iosAudioModeVoicePrompt = 'iosAudioModeVoicePrompt';

enum TextToSpeechPlatform { android, ios }

enum IosTextToSpeechAudioCategory {
  ambientSolo,

  ambient,

  playback,

  playAndRecord,
}

enum IosTextToSpeechAudioMode {
  defaultMode,
  gameChat,
  measurement,
  moviePlayback,
  spokenAudio,
  videoChat,
  videoRecording,
  voiceChat,
  voicePrompt,
}

enum IosTextToSpeechAudioCategoryOptions {

  mixWithOthers,

  duckOthers,

  interruptSpokenAudioAndMixWithOthers,

  allowBluetooth,

  allowBluetoothA2DP,

  allowAirPlay,

  defaultToSpeaker,
}

class SpeechRateValidRange {
  final double min;
  final double normal;
  final double max;
  final TextToSpeechPlatform platform;

  SpeechRateValidRange(this.min, this.normal, this.max, this.platform);
}

// Provides Platform specific TTS services (Android: TextToSpeech, IOS: AVSpeechSynthesizer)
class FlutterTts {
  static const MethodChannel _channel = MethodChannel('flutter_tts');

  VoidCallback? startHandler;
  VoidCallback? completionHandler;
  VoidCallback? pauseHandler;
  VoidCallback? continueHandler;
  VoidCallback? cancelHandler;
  ProgressHandler? progressHandler;
  ErrorHandler? errorHandler;

  FlutterTts() {
    _channel.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> awaitSpeakCompletion(bool awaitCompletion) async =>
      _channel.invokeMethod('awaitSpeakCompletion', awaitCompletion);

  Future<dynamic> awaitSynthCompletion(bool awaitCompletion) async =>
      _channel.invokeMethod('awaitSynthCompletion', awaitCompletion);

  Future<dynamic> speak(String text) async =>
      _channel.invokeMethod('speak', text);

  Future<dynamic> pause() async => _channel.invokeMethod('pause');

  Future<int?> get getMaxSpeechInputLength async {
    return await _channel.invokeMethod<int?>('getMaxSpeechInputLength');
  }

  Future<dynamic> synthesizeToFile(String text, String fileName) async =>
      _channel.invokeMethod('synthesizeToFile', <String, dynamic>{
        "text": text,
        "fileName": fileName,
      });

  Future<dynamic> setLanguage(String language) async =>
      _channel.invokeMethod('setLanguage', language);

  Future<dynamic> setSpeechRate(double rate) async =>
      _channel.invokeMethod('setSpeechRate', rate);

  Future<dynamic> setVolume(double volume) async =>
      _channel.invokeMethod('setVolume', volume);

  Future<dynamic> setSharedInstance(bool sharedSession) async =>
      _channel.invokeMethod('setSharedInstance', sharedSession);

  Future<dynamic> setIosAudioCategory(IosTextToSpeechAudioCategory category,
      List<IosTextToSpeechAudioCategoryOptions> options,
      [IosTextToSpeechAudioMode mode =
          IosTextToSpeechAudioMode.defaultMode]) async {
    const categoryToString = <IosTextToSpeechAudioCategory, String>{
      IosTextToSpeechAudioCategory.ambientSolo: iosAudioCategoryAmbientSolo,
      IosTextToSpeechAudioCategory.ambient: iosAudioCategoryAmbient,
      IosTextToSpeechAudioCategory.playback: iosAudioCategoryPlayback
    };
    const optionsToString = {
      IosTextToSpeechAudioCategoryOptions.mixWithOthers:
      'iosAudioCategoryOptionsMixWithOthers',
      IosTextToSpeechAudioCategoryOptions.duckOthers:
      'iosAudioCategoryOptionsDuckOthers',
      IosTextToSpeechAudioCategoryOptions.interruptSpokenAudioAndMixWithOthers:
      'iosAudioCategoryOptionsInterruptSpokenAudioAndMixWithOthers',
      IosTextToSpeechAudioCategoryOptions.allowBluetooth:
      'iosAudioCategoryOptionsAllowBluetooth',
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP:
      'iosAudioCategoryOptionsAllowBluetoothA2DP',
      IosTextToSpeechAudioCategoryOptions.allowAirPlay:
      'iosAudioCategoryOptionsAllowAirPlay',
      IosTextToSpeechAudioCategoryOptions.defaultToSpeaker:
      'iosAudioCategoryOptionsDefaultToSpeaker',
    };
    const modeToString = <IosTextToSpeechAudioMode, String>{
      IosTextToSpeechAudioMode.defaultMode: iosAudioModeDefault,
      IosTextToSpeechAudioMode.gameChat: iosAudioModeGameChat,
      IosTextToSpeechAudioMode.measurement: iosAudioModeMeasurement,
      IosTextToSpeechAudioMode.moviePlayback: iosAudioModeMoviePlayback,
      IosTextToSpeechAudioMode.spokenAudio: iosAudioModeSpokenAudio,
      IosTextToSpeechAudioMode.videoChat: iosAudioModeVideoChat,
      IosTextToSpeechAudioMode.videoRecording: iosAudioModeVideoRecording,
      IosTextToSpeechAudioMode.voiceChat: iosAudioModeVoiceChat,
      IosTextToSpeechAudioMode.voicePrompt: iosAudioModeVoicePrompt,
    };
    if (!Platform.isIOS) return;
    try {
      return _channel
          .invokeMethod<dynamic>('setIosAudioCategory', <String, dynamic>{
        iosAudioCategoryKey: categoryToString[category],
        iosAudioCategoryOptionsKey:
        options.map((o) => optionsToString[o]).toList(),
        iosAudioModeKey: modeToString[mode],
      });
    } on PlatformException catch (e) {
      print(
          'setIosAudioCategory error, category: $category, mode: $mode, error: ${e.message}');
    }
  }

  Future<dynamic> setEngine(String engine) =>
      _channel.invokeMethod('setEngine', engine);

  Future<dynamic> setPitch(double pitch) async =>
      _channel.invokeMethod('setPitch', pitch);

  Future<dynamic> setVoice(Map<String, String> voice) async =>
      _channel.invokeMethod('setVoice', voice);

  Future<dynamic> stop() async => _channel.invokeMethod('stop');

  Future<dynamic> get getLanguages async {
    final languages = await _channel.invokeMethod('getLanguages');
    return languages;
  }

  Future<dynamic> get getEngines async {
    final engines = await _channel.invokeMethod('getEngines');
    return engines;
  }

  Future<dynamic> get getDefaultEngine async {
    final engineName = await _channel.invokeMethod('getDefaultEngine');
    print(engineName);
    return engineName;
  }

  Future<dynamic> get getVoices async {
    final voices = await _channel.invokeMethod('getVoices');
    return voices;
  }

  Future<dynamic> isLanguageAvailable(String language) async =>
      _channel.invokeMethod('isLanguageAvailable', language);

  Future<dynamic> isLanguageInstalled(String language) =>
      _channel.invokeMethod('isLanguageInstalled', language);

  Future<dynamic> areLanguagesInstalled(List<String> languages) =>
      _channel.invokeMethod('areLanguagesInstalled', languages);

  Future<SpeechRateValidRange> get getSpeechRateValidRange async {
    final validRange = await _channel.invokeMethod('getSpeechRateValidRange')
    as Map<dynamic, dynamic>;
    final min = double.parse(validRange['min'].toString());
    final normal = double.parse(validRange['normal'].toString());
    final max = double.parse(validRange['max'].toString());
    final platformStr = validRange['platform'].toString();
    final platform = TextToSpeechPlatform.values
        .firstWhere((e) => describeEnum(e) == platformStr);

    return SpeechRateValidRange(min, normal, max, platform);
  }

  Future<dynamic> setSilence(int timems) async =>
      _channel.invokeMethod('setSilence', timems);

  Future<dynamic> setQueueMode(int queueMode) async =>
      _channel.invokeMethod('setQueueMode', queueMode);

  void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void setContinueHandler(VoidCallback callback) {
    continueHandler = callback;
  }

  void setPauseHandler(VoidCallback callback) {
    pauseHandler = callback;
  }

  void setCancelHandler(VoidCallback callback) {
    cancelHandler = callback;
  }

  void setProgressHandler(ProgressHandler callback) {
    progressHandler = callback;
  }

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  Future platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "speak.onStart":
        if (startHandler != null) {
          startHandler!();
        }
        break;
      case "synth.onStart":
        if (startHandler != null) {
          startHandler!();
        }
        break;
      case "speak.onComplete":
        if (completionHandler != null) {
          completionHandler!();
        }
        break;
      case "synth.onComplete":
        if (completionHandler != null) {
          completionHandler!();
        }
        break;
      case "speak.onPause":
        if (pauseHandler != null) {
          pauseHandler!();
        }
        break;
      case "speak.onContinue":
        if (continueHandler != null) {
          continueHandler!();
        }
        break;
      case "speak.onCancel":
        if (cancelHandler != null) {
          cancelHandler!();
        }
        break;
      case "speak.onError":
        if (errorHandler != null) {
          errorHandler!(call.arguments);
        }
        break;
      case 'speak.onProgress':
        if (progressHandler != null) {
          final args = call.arguments as Map<dynamic, dynamic>;
          progressHandler!(
            args['text'].toString(),
            int.parse(args['start'].toString()),
            int.parse(args['end'].toString()),
            args['word'].toString(),
          );
        }
        break;
      case "synth.onError":
        if (errorHandler != null) {
          errorHandler!(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method}');
    }
  }
}
