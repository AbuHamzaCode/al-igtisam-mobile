import 'package:flutter/material.dart';

import '../../utils/common.dart';
import '../../utils/size_config.dart';

class VideoItemCard extends StatelessWidget {
  VideoItemCard({Key? key, this.videoItem}) : super(key: key);
  var videoItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        child: Row(
          children: [
            Container(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(150),
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              margin: const EdgeInsets.only(bottom: 10.0),
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
                        "${videoItem?.snippet?.thumbnails?.high?.url}"),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Container(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(190),
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${videoItem?.snippet?.title}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${videoItem?.snippet?.channelTitle}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${getDateFormat(videoItem?.snippet?.publishedAt)}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ]),
            ),
          ],
        ));
  }
}
