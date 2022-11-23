import 'package:al_igtisam/models/channel_info.dart';
import 'package:al_igtisam/models/play_list_model.dart';
import 'package:al_igtisam/models/video_model.dart';
import 'package:al_igtisam/utils/constants.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';

import '../models/play_list_items.dart';

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

    if (response.statusCode == 200) {
      data = ChannelInfo.fromJson(response.data);

      debugPrint("channel info success");
      return data;
    } else {
      debugPrint("${response.data.error.message}");
      return null;
    }
  }

  Future<Playlists?> getPlaylists({String? pageToken}) async {
    if (pageToken == null) {
      return null;
    }
    Map<String, dynamic> params = {
      'part': 'snippet',
      'channelId': Constants.CHANNEL_ID,
      'maxResults': 8,
      'pageToken': pageToken,
      'key': Constants.API_KEY,
    };
    Playlists data;
    var response = await dio.get('$baseUrl/youtube/v3/playlists',
        queryParameters: params,
        options: Options(validateStatus: (status) => true));

    if (response.statusCode == 200) {
      data = Playlists.fromJson(response.data);
      debugPrint("playlist success");
      return data;
    } else {
      debugPrint("${response.data.error.message}");
      return null;
    }
  }

  Future<PlayListItemsModel?> getPlaylistItems(
      {String? playlistId, String? pageToken}) async {
    if (pageToken == null) {
      return null;
    }
    Map<String, dynamic> params = {
      'part': 'snippet,contentDetails',
      'playlistId': playlistId,
      'maxResults': 8,
      'pageToken': pageToken,
      'key': Constants.API_KEY,
    };
    PlayListItemsModel data;
    var response = await dio.get('$baseUrl/youtube/v3/playlistItems',
        queryParameters: params,
        options: Options(validateStatus: (status) => true));

    if (response.statusCode == 200) {
      data = PlayListItemsModel.fromJson(response.data);
      debugPrint("playlist items success");
      return data;
    } else {
      // debugPrint("${response.data[0].error.message}"); //some error need to check
      return null;
    }
  }

  Future<VideoModel?> getVideoDesc({String? videoId}) async {
    if (videoId == null) {
      return null;
    }
    Map<String, dynamic> params = {
      'part': 'snippet,contentDetails,statistics',
      'id': videoId,
      'key': Constants.API_KEY,
    };
    VideoModel data;
    var response = await dio.get('$baseUrl/youtube/v3/videos',
        queryParameters: params,
        options: Options(validateStatus: (status) => true));

    if (response.statusCode == 200) {
      data = VideoModel.fromJson(response.data);
      debugPrint("video model success");
      return data;
    } else {
      debugPrint("${response.data.error.message}");
      return null;
    }
  }
}
