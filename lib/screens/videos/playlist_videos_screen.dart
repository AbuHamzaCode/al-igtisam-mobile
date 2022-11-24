import 'package:al_igtisam/models/play_list_items.dart';
import 'package:al_igtisam/screens/videos/video_player_screen.dart';
import 'package:flutter/material.dart';

import '../../services/services.dart';
import '../../utils/size_config.dart';
import '../widgets/list_item_card.dart';

class PlaylistVideosScreen extends StatefulWidget {
  PlaylistVideosScreen({
    Key? key,
    this.playlistId,
    this.title,
  }) : super(key: key);

  var playlistId;
  var title;

  @override
  State<PlaylistVideosScreen> createState() => _PlaylistVideosScreenState();
}

class _PlaylistVideosScreenState extends State<PlaylistVideosScreen> {
  PlayListItemsModel? _playlistItems;
  Services? services;
  String? _nextPageToken;
  var isLoading = false;
  var hasMore = true;
  final _scrollController = ScrollController();

  _loadPlaylistItems() async {
    if (isLoading) return;
    isLoading = true;
    PlayListItemsModel? tempPlaylistItems = await services!.getPlaylistItems(
        playlistId: widget.playlistId, pageToken: _nextPageToken);

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
    _playlistItems = PlayListItemsModel();
    _playlistItems?.items = [];
    services = Services();
    _nextPageToken = '';
    _loadPlaylistItems();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _loadPlaylistItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(240),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
              color: Colors.black87,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  left: 0,
                  child: Container(
                    height: getProportionateScreenHeight(100),
                    width: getProportionateScreenWidth(250),
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 25,
                  child: SizedBox(
                    height: getProportionateScreenHeight(70),
                    width: getProportionateScreenWidth(190),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.title.length > 60
                                ? "${widget.title.substring(0, 60)}..."
                                : "${widget.title}",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  top: 11,
                  right: 0,
                  child: IconButton(
                    iconSize: getProportionateScreenHeight(80),
                    icon: const Icon(
                      Icons.arrow_left_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VideoPlayerScreen(
                          videoItem: item,
                          playListId: widget.playlistId,
                        );
                      }));
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
          ))
        ],
      ),
    );
  }
}
