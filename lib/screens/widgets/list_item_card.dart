import 'package:flutter/material.dart';

import '../../models/channel_info.dart';

class ListItemCard extends StatelessWidget {
  final ChannelInfo channelInfo;

  const ListItemCard({
    Key? key,
    required this.channelInfo,
  }) : super(key: key);

  // get title => channelInfo.items![0].snippet!.title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 3.0),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Image.network(
                  '${channelInfo.items![0].snippet!.thumbnails!.medium!.url}',
                  width: 90.0,
                  height: 90.0,
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      '${channelInfo.items![0].snippet!.title}',
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      "time and date",
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
