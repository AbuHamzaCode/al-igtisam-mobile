import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/common.dart';

class PlaylistItem extends StatelessWidget {
  PlaylistItem({
    Key? key,
    this.currentItem,
  }) : super(key: key);

  final currentItem;
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
                      fit: BoxFit.cover,
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
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Text(
                      "${getDateFormat(currentItem?.snippet?.publishedAt)}",
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
