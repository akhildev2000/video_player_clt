import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoplayer/components/my_drawer.dart';
import 'package:videoplayer/services/video_list_provider.dart';
import 'package:videoplayer/models/videos.dart';
import 'package:videoplayer/pages/video_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.user});
  final User? user;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get the videolist provider
  late final dynamic videoListProvider;

  @override
  void initState() {
    videoListProvider = Provider.of<VideoListProvider>(context, listen: false);
    super.initState();
  }

  //go to a video
  void goToVideo(int videoIndex) async {
    // update current index
    videoListProvider.currentVideoIndex = videoIndex;

    // check if the video file exists in the device
    final video = Provider.of<VideoListProvider>(context, listen: false)
        .videosList[videoIndex];
    final videoName = 'encrypted_${video.videoName}.mp4';
    final videoFile = File(videoName);
    if (videoFile.existsSync()) {
      // play the video from the device
      videoListProvider.currentVideoSrc = 'file://${videoFile.path}';
    } else {
      // download and encrypt the video
      await videoListProvider.downloadVideo(videoIndex);
      // play the video from the device
      videoListProvider.currentVideoSrc = 'file://${videoFile.path}.encrypted';
    }

    // navigate to video page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VideoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'P L A Y L I S T',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      drawer: MyDrawer(
        phoneNUmber: widget.user!.phoneNumber.toString(),
      ),
      body: Consumer<VideoListProvider>(
        builder: (context, value, child) {
          final List<Videos> videoList = value.videosList;
          return ListView.builder(
            itemBuilder: (context, index) {
              final Videos video = videoList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.secondary,
                  title: Text(
                    video.videoName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  leading: Icon(
                    Icons.video_collection_rounded,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  trailing: Icon(
                    Icons.download,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onTap: () {
                    goToVideo(index);
                  },
                ),
              );
            },
            itemCount: videoList.length,
          );
        },
      ),
    );
  }
}
