import 'package:al_igtisam/models/video_model.dart';
import 'package:al_igtisam/services/services.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/channel_info.dart';
import '../../models/play_list_items.dart';
import '../../utils/common.dart';
import '../widgets/list_item_card.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({
    Key? key,
    this.videoItem,
    // this.playlistId,
  }) : super(key: key);

  var videoItem;
  // var playlistId;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  var _isPlayerReady = false;
  var services = Services();
  PlayListItemsModel? _playlistItems;
  VideoModel? videoInfo;
  ChannelInfo? _channelInfo;
  String? _nextPageToken;
  final _scrollController = ScrollController();

  var isLoading = false;
  var isLiked = false;
  var hasMore = true;

  _getVideoInfo() async {
    // if (isLoading) return;
    // isLoading = true;
    videoInfo = await services.getVideoDesc(
        videoId: widget.videoItem.contentDetails.videoId);
    debugPrint("${widget.videoItem}      -> video title ");
    if (videoInfo != null) {
      setState(() {});
    }
  }

  _getChannelInfo() async {
    ChannelInfo? tempChannelInfo = await services.getChannelInfo();
    if (tempChannelInfo != null) {
      setState(() {
        _channelInfo = tempChannelInfo;
      });
    }
  }

  _loadPlaylistItems() async {
    if (isLoading) return;
    isLoading = true;
    PlayListItemsModel? tempPlaylistItems = await services.getPlaylistItems(
        playlistId: widget.videoItem.id, pageToken: _nextPageToken);

    if (tempPlaylistItems != null) {
      _nextPageToken = tempPlaylistItems.nextPageToken;
      setState(() {
        isLoading = false;
        if (tempPlaylistItems.items!.length < 8) {
          hasMore = false;
        }
        _playlistItems!.items!
            .addAll(tempPlaylistItems.items as Iterable<ItemsOfPlaylistItem>);
      });
    } else {
      setState(() {
        hasMore = false;
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      _nextPageToken = '';
      _playlistItems!.items!.clear();
    });

    _loadPlaylistItems();
  }

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    videoInfo = VideoModel();
    _channelInfo = ChannelInfo();
    _playlistItems = PlayListItemsModel();
    _playlistItems?.items = [];
    _nextPageToken = '';

    // debugPrint("${widget.videoItem.contentDetails.videoId}");
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.contentDetails.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: false, //fix to "true" after complete this page
        forceHD: true,
      ),
    )..addListener(_listener);
    _getVideoInfo();
    _getChannelInfo();
    _loadPlaylistItems();
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      //
    }
  }

  // @override
  // void didUpdateWidget(covariant VideoPlayerScreen oldWidget) {
  //   if (oldWidget.videoItem != null) {
  //   }
  //   if (isLoading) {
  //     _getChannelInfo();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(31),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
          Container(
              child: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.black87,
            onReady: () {
              _isPlayerReady = true;
            },
          )),
          // avatar and title
          SizedBox(
            height: getProportionateScreenHeight(60),
            width: getProportionateScreenWidth(370),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${widget.videoItem.snippet.thumbnails.medium.url}"),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.videoItem.snippet.title.length > 35
                              ? "${widget.videoItem.snippet.title.substring(0, 35)}..."
                              : "${widget.videoItem.snippet.title}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          "${getViews("${videoInfo?.items?[0].statistics?.viewCount}")} views —— ${getDateFormat(videoInfo?.items?[0].snippet?.publishedAt)}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          // small buttons
          SizedBox(
            height: getProportionateScreenHeight(80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // like count
                SizedBox(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(60),
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(isLiked
                              ? const Color.fromARGB(255, 243, 147, 145)
                              : Colors.grey)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: isLiked
                                ? const Color.fromARGB(255, 243, 7, 3)
                                : const Color.fromARGB(255, 81, 78, 78),
                            size: 20.0,
                          ),
                          Text(
                            "${getViews("${videoInfo?.items?[0].statistics?.likeCount}")}",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: isLiked
                                  ? const Color.fromARGB(255, 243, 7, 3)
                                  : const Color.fromARGB(255, 81, 78, 78),
                            ),
                          ),
                        ],
                      )),
                ),
                // comment count
                SizedBox(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(60),
                  child: ElevatedButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 237, 196, 119))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.comment_rounded,
                            color: Color.fromARGB(255, 228, 154, 17),
                            size: 20.0,
                          ),
                          Text(
                            "${getViews("${videoInfo?.items?[0].statistics?.commentCount}")}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 228, 154, 17),
                            ),
                          ),
                        ],
                      )),
                ),
                // share
                SizedBox(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(60),
                  child: ElevatedButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 54, 179, 228))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.share_rounded,
                            color: Color.fromARGB(255, 41, 87, 195),
                            size: 20.0,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 41, 87, 195),
                            ),
                          ),
                        ],
                      )),
                ),
                // save
                SizedBox(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(60),
                  child: ElevatedButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 135, 225, 183))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.save_alt_rounded,
                            color: Color.fromARGB(255, 22, 199, 114),
                            size: 20.0,
                          ),
                          Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 22, 199, 114),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          // Subscribe
          Container(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(350),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(255, 223, 218, 218)
                          .withOpacity(0.2),
                      // offset: const Offset(10.0, 10.0),
                      blurRadius: 10.0,
                      spreadRadius: 4.0),
                ],
                border:
                    Border.all(color: const Color.fromARGB(255, 230, 229, 229)),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      "${getViews("${_channelInfo?.items?[0].statistics?.subscriberCount}")} Subscribers",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Color.fromARGB(255, 12, 12, 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(35),
                    width: getProportionateScreenWidth(95),
                    child: ElevatedButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 243, 7, 3))),
                      child: const Text(
                        "Subscribe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Color.fromARGB(255, 252, 252, 252),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "${getViews("${videoInfo?.items?[0].statistics?.commentCount}")} Comments",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Color.fromARGB(143, 162, 153, 153),
                      ),
                    ),
                  )
                ],
              )),
          // tags
          Container(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenWidth(350),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 15.0, left: 5.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoInfo?.items?[0].snippet?.tags?.length,
                itemBuilder: ((context, index) {
                  final item = videoInfo?.items?[0].snippet?.tags?[index];
                  return Text(
                    "#$item     ",
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color.fromARGB(254, 66, 51, 229),
                    ),
                  );
                }),
              )),
          Container(
              height: getProportionateScreenHeight(30),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 15.0),
              child: const Text(
                "Playlist Videos",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Color.fromARGB(255, 16, 15, 15),
                ),
              )),
          Expanded(
              child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _playlistItems!.items!.length + 1,
              itemBuilder: (context, index) {
                if (index < _playlistItems!.items!.length) {
                  final item = _playlistItems?.items?[index];
                  // debugPrint("${item?.id}");
                  return InkWell(
                    onTap: () async {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return VideoPlayerScreen(
                      //     videoItem: item,
                      //     playlistId: widget.playlistId,
                      //   );
                      // }));
                    },
                    child: PlaylistItem(currentItem: item),
                  );
                } else {
                  return hasMore
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.black87,
                          )))
                      : null;
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
