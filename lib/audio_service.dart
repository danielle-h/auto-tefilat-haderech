import 'package:just_audio/just_audio.dart';

class AudioServiceSingleton {
  // Private constructor
  AudioServiceSingleton._internal() {
    print("HOME AudioServiceSingleton initialized");
  }

  // The one and only instance
  static final AudioServiceSingleton _instance =
      AudioServiceSingleton._internal();

  // Public getter
  static AudioServiceSingleton get instance => _instance;

  // Audio player
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> playAsset(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      print("Error playing asset: $e");
    }
  }

  Future<void> setAsset(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
    } catch (e) {
      print("Error setting asset: $e");
    }
  }

  Future<void> setFile(String filePath) async {
    try {
      await _player.setFilePath(filePath);
    } catch (e) {
      print("Error setting file: $e");
    }
  }

  Future<void> play() async {
    if (_player.playing) return; // Avoid playing if already playing
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  bool get isPlaying => _player.playing;
}
