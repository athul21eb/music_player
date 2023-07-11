import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuaery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var isPlaying = false.obs;
  var playerindex = 0.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var pvalue = 0.0.obs;
  @override
  void onInit() {
    super.onInit();

    checkPermission();
  }

  changeDurationtoSeconds(seconds) {
    var dur = Duration(seconds: seconds);

    audioPlayer.seek(dur);
  }

  updateposition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });

    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      pvalue.value = p.inSeconds.toDouble();
    });
  }

  play({String? uri, index}) async {
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );

      audioPlayer.play();

      playerindex(index);

      isPlaying(true);
      updateposition();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  checkPermission() async {
    final perm = await Permission.storage.request();

    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}
