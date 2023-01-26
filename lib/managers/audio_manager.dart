import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioComponent extends Component {
  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();

    FlameAudio.audioCache.loadAll(
        ['bg_audio.mp3', 'Coin.wav', 'heartbeat.wav', 'hurt.wav', 'Jump.wav']);

    return super.onLoad();
  }

  Future<void> playBGM(String fileName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if ((sp.getBool('BGM') ?? true) == true) {
      FlameAudio.bgm.play(fileName, volume: 0.5);
    }
  }

  Future<void> playSFX(String fileName, double volume) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if ((sp.getBool('SFX') ?? true) == true) {
      FlameAudio.play(fileName, volume: volume);
    }
  }

  void stopBGM() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }

  void pauseBGM() {
    FlameAudio.bgm.pause();
  }

  void resumeBGM() {
    FlameAudio.bgm.resume();
  }
}
