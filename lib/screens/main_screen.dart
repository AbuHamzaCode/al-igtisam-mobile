import 'package:al_igtisam/screens/detail/detail_screen.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../models/channel_info.dart';
import '../services/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ChannelInfo? _channelInfo;
  // VideosList _videosList;
  // Item _item;
  bool? _loading;
  // String? _playListId;
  // String? _nextPageToken;
  ScrollController? _scrollController;

  Services? services;
  _getChannelInfo() async {
    _channelInfo = await services!.getChannelInfo();
    debugPrint(
        "${_channelInfo!.items![0].snippet!.title}      -> from screen ");
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    _channelInfo = ChannelInfo();
    services = Services();
    // _nextPageToken = '';
    _scrollController = ScrollController();
    _getChannelInfo();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Al-Igtisam")),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(100),
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(channelInfo: _channelInfo!))),
                  child: const Text(" Detail Screen"))),
        ));
  }
}
