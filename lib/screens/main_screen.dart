import 'package:al_igtisam/models/play_list_model.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/channel_info.dart';
import '../services/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ChannelInfo? _channelInfo;
  Playlists? _playlists;
  var isLoading = false;
  var hasMore = true;
  String? _nextPageToken;
  final _scrollController = ScrollController();

  Services? services;

  _getChannelInfo() async {
    _channelInfo = await services!.getChannelInfo();
    debugPrint(
        "${_channelInfo!.items![0].snippet!.title}      -> from screen ");
    setState(() {
      isLoading = false;
    });
  }

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
    _channelInfo = ChannelInfo();
    _playlists = Playlists();
    _playlists?.items = [];
    services = Services();
    _nextPageToken = '';
    _loadPlaylists();
    _getChannelInfo();
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
      // appBar: AppBar(
      //   title: Center(
      //     child: SizedBox(
      //         height: getProportionateScreenHeight(50),
      //         width: getProportionateScreenWidth(200),
      //         child: TextButton(
      //             onPressed: () => Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) =>
      //                         DetailScreen(channelInfo: _channelInfo!))),
      //             child: Text(
      //               "${_channelInfo?.items?[0].snippet?.title}",
      //               style: const TextStyle(color: Colors.black),
      //             ))),
      //   ),
      // ),
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
                  return InkWell(
                    onTap: () async {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return VideoPlayerScreen(
                      //     videoItem: videoItem,
                      //   );
                      // }));
                    },
                    child: PlaylistItem(currentItem: item),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: hasMore
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.black87,
                            ))
                          : const Text("No more playlists"));
                }
              },
            ),
          ))
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  PlaylistItem({
    Key? key,
    this.currentItem,
  }) : super(key: key);

  final ItemsOfPlaylist? currentItem;
  final formatter = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(200),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 15,
            child: Material(
              child: Container(
                height: getProportionateScreenHeight(150),
                width: getProportionateScreenWidth(340),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 30, 27, 27)
                            .withOpacity(0.3),
                        offset: const Offset(-10.0, 10.0),
                        blurRadius: 20.0,
                        spreadRadius: 4.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 25,
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: getProportionateScreenHeight(150),
                width: getProportionateScreenWidth(130),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 249, 247, 247)
                              .withOpacity(0.3),
                          offset: const Offset(-10.0, 10.0),
                          blurRadius: 20.0,
                          spreadRadius: 4.0),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                          "${currentItem?.snippet?.thumbnails?.high?.url}"),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
          Positioned(
            top: 31,
            left: 167,
            child: SizedBox(
              height: getProportionateScreenHeight(130),
              width: getProportionateScreenWidth(178),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${currentItem?.snippet?.title}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Text(
                      formatter.format(DateTime.parse(
                          '${currentItem?.snippet?.publishedAt}')),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
