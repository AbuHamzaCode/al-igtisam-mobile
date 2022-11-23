import 'package:al_igtisam/models/play_list_model.dart';
import 'package:al_igtisam/screens/widgets/list_item_card.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';
import 'videos/playlist_videos_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Playlists? _playlists;
  var isLoading = false;
  var hasMore = true;
  String? _nextPageToken;
  final _scrollController = ScrollController();

  Services? services;

  _loadPlaylists() async {
    if (isLoading) return;
    isLoading = true;
    Playlists? tempPlaylists =
        await services!.getPlaylists(pageToken: _nextPageToken);

    if (tempPlaylists != null) {
      _nextPageToken = tempPlaylists.nextPageToken;
      setState(() {
        isLoading = false;
        if (tempPlaylists.items!.length < 8) {
          hasMore = false;
        }
        _playlists!.items!
            .addAll(tempPlaylists.items as Iterable<ItemsOfPlaylist>);
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
      _playlists!.items!.clear();
    });

    _loadPlaylists();
  }

  @override
  void initState() {
    super.initState();
    _playlists = Playlists();
    _playlists?.items = [];
    services = Services();
    _nextPageToken = '';
    _loadPlaylists();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _loadPlaylists();
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
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                const Positioned(
                  top: 110,
                  left: 25,
                  child: Text(
                    "Playlist",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                    ),
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
                    onPressed: () => {debugPrint("press back button")},
                    // Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: getProportionateScreenHeight(20),
          // ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _playlists!.items!.length + 1,
              itemBuilder: (context, index) {
                if (index < _playlists!.items!.length) {
                  final item = _playlists?.items?[index];
                  // debugPrint("${item?.id}");
                  return InkWell(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PlaylistVideosScreen(
                          playlistId: item?.id,
                          title: item?.snippet?.title,
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
