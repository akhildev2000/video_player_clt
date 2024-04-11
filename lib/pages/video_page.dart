
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/components/neu_box.dart';
import 'package:videoplayer/services/video_list_provider.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<VideoListProvider>(context, listen: false);
    final video = provider.videosList[provider.currentVideoIndex!];
    _videoPlayerController = VideoPlayerController.network(video.videoSrc);
    flickManager = FlickManager(
      autoInitialize: true,
      videoPlayerController: _videoPlayerController,
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying) {
        provider.currentVideoIndex = provider.currentVideoIndex;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoListProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Text('Video'),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                      ],
                    ),
                    NeuBox(
                      child: Column(
                        children: [
                          FlickVideoPlayer(
                            flickManager: flickManager,
                            flickVideoWithControls:
                                const FlickVideoWithControls(
                              closedCaptionTextStyle: TextStyle(fontSize: 8),
                              controls: FlickPortraitControls(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Video 1"),
                                  ],
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
