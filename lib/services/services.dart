import 'package:al_igtisam/models/channel_info.dart';
import 'package:al_igtisam/utils/constants.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';

class Services {
  final dio = Dio();
  final baseUrl = Constants.BASE_URL;

  Future<ChannelInfo?> getChannelInfo() async {
    Map<String, dynamic> params = {
      'part': 'snippet,contentDetails,statistics',
      'id': Constants.CHANNEL_ID,
      'key': Constants.API_KEY,
    };
    ChannelInfo data;
    var response = await dio.get('$baseUrl/youtube/v3/channels',
        queryParameters: params,
        options: Options(validateStatus: (status) => true));
    debugPrint('${response.statusCode}   <- status code');
    if (response.statusCode == 200) {
      data = ChannelInfo.fromJson(response.data);
      debugPrint("${data.items![0].snippet!.title}        -> from service");
      return data;
    } else {
      debugPrint("${response.statusCode}");
      return null;
    }
  }
}
