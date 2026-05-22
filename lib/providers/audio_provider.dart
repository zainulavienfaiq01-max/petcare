import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isBgmEnabled = true;
  bool _isSfxEnabled = true;

  bool get isBgmEnabled => _isBgmEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  AudioProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isBgmEnabled = prefs.getBool('bgm_enabled') ?? true;
    _isSfxEnabled = prefs.getBool('sfx_enabled') ?? true;

    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    if (_isBgmEnabled) {
      _playBgm();
    }
    notifyListeners();
  }

  Future<void> toggleBgm() async {
    _isBgmEnabled = !_isBgmEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bgm_enabled', _isBgmEnabled);
    if (_isBgmEnabled) {
      _playBgm();
    } else {
      _stopBgm();
    }
    notifyListeners();
  }

  Future<void> toggleSfx() async {
    _isSfxEnabled = !_isSfxEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sfx_enabled', _isSfxEnabled);
    notifyListeners();
  }

  Future<void> _playBgm() async {
    await _bgmPlayer.play(AssetSource('audio/bgm.mp3'), volume: 0.3);
  }

  Future<void> _stopBgm() async {
    await _bgmPlayer.stop();
  }

  void playRegularClick() {
    if (_isSfxEnabled) {
      _sfxPlayer.play(AssetSource('audio/click.mp3'));
    }
  }

  void playMenuClick() {
    if (_isSfxEnabled) {
      _sfxPlayer.play(AssetSource('audio/menu.mp3'));
    }
  }

  void playActionClick() {
    if (_isSfxEnabled) {
      _sfxPlayer.play(AssetSource('audio/action.mp3'));
    }
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}
