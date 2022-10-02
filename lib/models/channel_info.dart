class ChannelInfo {
  String? kind;
  String? etag;
  PageInfo? pageInfo;
  List<Items>? items;

  ChannelInfo({this.kind, this.etag, this.pageInfo, this.items});

  ChannelInfo.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    pageInfo =
        json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    if (pageInfo != null) {
      data['pageInfo'] = pageInfo!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  int? totalResults;
  int? resultsPerPage;

  PageInfo({this.totalResults, this.resultsPerPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['totalResults'];
    resultsPerPage = json['resultsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalResults'] = totalResults;
    data['resultsPerPage'] = resultsPerPage;
    return data;
  }
}

class Items {
  String? kind;
  String? etag;
  String? id;
  Snippet? snippet;
  ContentDetails? contentDetails;
  Statistics? statistics;

  Items(
      {this.kind,
      this.etag,
      this.id,
      this.snippet,
      this.contentDetails,
      this.statistics});

  Items.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    snippet =
        json['snippet'] != null ? Snippet.fromJson(json['snippet']) : null;
    contentDetails = json['contentDetails'] != null
        ? ContentDetails.fromJson(json['contentDetails'])
        : null;
    statistics = json['statistics'] != null
        ? Statistics.fromJson(json['statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    data['id'] = id;
    if (snippet != null) {
      data['snippet'] = snippet!.toJson();
    }
    if (contentDetails != null) {
      data['contentDetails'] = contentDetails!.toJson();
    }
    if (statistics != null) {
      data['statistics'] = statistics!.toJson();
    }
    return data;
  }
}

class Snippet {
  String? title;
  String? description;
  String? publishedAt;
  Thumbnails? thumbnails;
  Localized? localized;
  String? country;

  Snippet(
      {this.title,
      this.description,
      this.publishedAt,
      this.thumbnails,
      this.localized,
      this.country});

  Snippet.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    publishedAt = json['publishedAt'];
    thumbnails = json['thumbnails'] != null
        ? Thumbnails.fromJson(json['thumbnails'])
        : null;
    localized = json['localized'] != null
        ? Localized.fromJson(json['localized'])
        : null;
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['publishedAt'] = publishedAt;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.toJson();
    }
    if (localized != null) {
      data['localized'] = localized!.toJson();
    }
    data['country'] = country;
    return data;
  }
}

class Thumbnails {
  Small? small;
  Small? medium;
  Small? high;

  Thumbnails({this.small, this.medium, this.high});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    small = json['default'] != null ? Small.fromJson(json['default']) : null;
    medium = json['medium'] != null ? Small.fromJson(json['medium']) : null;
    high = json['high'] != null ? Small.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (small != null) {
      data['default'] = small!.toJson();
    }
    if (medium != null) {
      data['medium'] = medium!.toJson();
    }
    if (high != null) {
      data['high'] = high!.toJson();
    }
    return data;
  }
}

class Small {
  String? url;
  int? width;
  int? height;

  Small({this.url, this.width, this.height});

  Small.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class Localized {
  String? title;
  String? description;

  Localized({this.title, this.description});

  Localized.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class ContentDetails {
  RelatedPlaylists? relatedPlaylists;

  ContentDetails({this.relatedPlaylists});

  ContentDetails.fromJson(Map<String, dynamic> json) {
    relatedPlaylists = json['relatedPlaylists'] != null
        ? RelatedPlaylists.fromJson(json['relatedPlaylists'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (relatedPlaylists != null) {
      data['relatedPlaylists'] = relatedPlaylists!.toJson();
    }
    return data;
  }
}

class RelatedPlaylists {
  String? likes;
  String? uploads;

  RelatedPlaylists({this.likes, this.uploads});

  RelatedPlaylists.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
    uploads = json['uploads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes'] = likes;
    data['uploads'] = uploads;
    return data;
  }
}

class Statistics {
  String? viewCount;
  String? subscriberCount;
  bool? hiddenSubscriberCount;
  String? videoCount;

  Statistics(
      {this.viewCount,
      this.subscriberCount,
      this.hiddenSubscriberCount,
      this.videoCount});

  Statistics.fromJson(Map<String, dynamic> json) {
    viewCount = json['viewCount'];
    subscriberCount = json['subscriberCount'];
    hiddenSubscriberCount = json['hiddenSubscriberCount'];
    videoCount = json['videoCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viewCount'] = viewCount;
    data['subscriberCount'] = subscriberCount;
    data['hiddenSubscriberCount'] = hiddenSubscriberCount;
    data['videoCount'] = videoCount;
    return data;
  }
}
