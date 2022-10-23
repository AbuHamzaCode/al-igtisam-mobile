import 'package:al_igtisam/models/play_list_model.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';

// import '../models/channel_info.dart';
import '../services/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ChannelInfo? _channelInfo;
  Playlists? _playlists;
  bool? _loading;
  String? _nextPageToken;
  ScrollController? _scrollController;

  Services? services;

  // _getChannelInfo() async {
  //   _channelInfo = await services!.getChannelInfo();
  //   debugPrint(
  //       "${_channelInfo!.items![0].snippet!.title}      -> from screen ");
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  _loadPlaylists() async {
    Playlists? tempPlaylists =
        await services!.getPlaylists(pageToken: _nextPageToken!);
    _nextPageToken = tempPlaylists?.nextPageToken;
    _playlists!.items!.addAll(tempPlaylists?.items as Iterable<Items>);
    debugPrint('length: ${tempPlaylists?.items?.length}');
    debugPrint('_nextPageToken $_nextPageToken');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    // _channelInfo = ChannelInfo();
    _playlists = Playlists();
    _playlists?.items = [];
    services = Services();
    _nextPageToken = '';
    _scrollController = ScrollController();
    _loadPlaylists();
    // _getChannelInfo();
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
      //             child: const Text(
      //               "Go to Detail",
      //               style: TextStyle(color: Colors.black),
      //             ))),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollEndNotification>(
                  onNotification: (ScrollNotification notification) {
                    var total =
                        _playlists?.pageInfo?.totalResults?.toInt() ?? 0;
                    if (_playlists!.items!.length >= total) {
                      return true;
                    }
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      _loadPlaylists();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _playlists?.items?.length,
                    itemBuilder: (context, index) {
                      Items playlist = _playlists!.items![index];
                      return InkWell(
                        onTap: () async {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return VideoPlayerScreen(
                          //     videoItem: videoItem,
                          //   );
                          // }));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.network(
                                  '${playlist.snippet?.thumbnails?.small?.url}'),
                              const SizedBox(width: 20),
                              Flexible(
                                  child: Text('${playlist.snippet?.title}')),
                            ],
                          ),
                        ),
                      );
                    },
                  )))
        ],
      ),
    );
  }
}
