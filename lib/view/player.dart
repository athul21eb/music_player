import 'package:beats/consts/sizebox.dart';
import 'package:beats/consts/text.dart';
import 'package:beats/controller/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:beats/consts/colors.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatelessWidget {
  final List<SongModel> songdata;
  const PlayerScreen({
    super.key,
    required this.songdata,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.85,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: slidercolor,
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    id: songdata[controller.playerindex.value].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      color: whitecolor,
                      size: 60,
                    ),
                  )),
            ),
            kheight,
            Expanded(
                child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: whitecolor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    25,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    kheight,
                    Text(
                      songdata[controller.playerindex.value].title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: ourStyle(
                        color: bgDarkcolor,
                        fontfamily: bold,
                        size: 25,
                      ),
                    ),
                    kheight,
                    Text(
                      songdata[controller.playerindex.value].artist!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: ourStyle(
                        color: bgDarkcolor,
                        fontfamily: regular,
                        size: 18,
                      ),
                    ),
                    kheight,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(
                                color: bgDarkcolor,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: slidercolor,
                                activeColor: slidercolor,
                                inactiveColor: bgcolor,
                                value: controller.pvalue.value,
                                max: controller.max.value,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                onChanged: (newvalue) {
                                  controller.changeDurationtoSeconds(
                                      newvalue.toInt());
                                  newvalue = newvalue;
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(
                                color: bgDarkcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    kheight,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.play(
                                index: controller.playerindex.value - 1,
                                uri: songdata[controller.playerindex.value - 1]
                                    .uri);
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 45,
                            color: bgDarkcolor,
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            backgroundColor: bgDarkcolor,
                            radius: 35,
                            child: Transform.scale(
                              scale: 3,
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.isTrue
                                    ? const Icon(
                                        Icons.pause,
                                        color: whitecolor,
                                        size: 20,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        color: whitecolor,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.play(
                                index: controller.playerindex.value + 1,
                                uri: songdata[controller.playerindex.value + 1]
                                    .uri);
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 45,
                            color: bgDarkcolor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
