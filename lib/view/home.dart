import 'package:beats/consts/colors.dart';
import 'package:beats/consts/text.dart';
import 'package:beats/controller/player_controller.dart';
import 'package:beats/view/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgDarkcolor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_rounded,
                  color: whitecolor,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whitecolor,
          ),
          title: Text(
            "Beatz",
            style: ourStyle(
              fontfamily: regular,
              size: 18,
            ),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Songs',
                  style: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (controller.isPlaying.value &&
                                  controller.playerindex == index) {
                                Get.to(
                                  () => PlayerScreen(songdata: snapshot.data!),
                                  transition: Transition.native,
                                );
                              } else {
                                controller.play(
                                    uri: snapshot.data![index].uri,
                                    index: index);
                                Get.to(
                                  () => PlayerScreen(songdata: snapshot.data!),
                                  transition: Transition.native,
                                );
                              }
                            },
                            onDoubleTap: () {
                              Get.to(
                                () => PlayerScreen(songdata: snapshot.data!),
                                transition: Transition.native,
                              );
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              tileColor: bgcolor,
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_rounded,
                                  color: whitecolor,
                                  size: 32,
                                ),
                              ),
                              trailing: controller.playerindex.value == index &&
                                      controller.isPlaying.isTrue
                                  ? const Icon(
                                      Icons.play_arrow_rounded,
                                      color: whitecolor,
                                      size: 26,
                                    )
                                  : null,
                              title: Text(
                                "${snapshot.data![index].title} ",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ourStyle(fontfamily: bold, size: 18),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist} ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ourStyle(fontfamily: regular, size: 12),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
          future: controller.audioQuaery.querySongs(
            ignoreCase: true,
            orderType: OrderType.DESC_OR_GREATER,
            sortType: SongSortType.DATE_ADDED,
            uriType: UriType.EXTERNAL,
          ),
        ));
  }
}
