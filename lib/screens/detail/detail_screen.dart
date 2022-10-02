import 'package:al_igtisam/models/channel_info.dart';
import 'package:al_igtisam/screens/detail/components/body.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final ChannelInfo channelInfo;

  const DetailScreen({Key? key, required this.channelInfo}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 25, 25, 255),
      body: Body(channelInfo: widget.channelInfo),
    );
  }
}
