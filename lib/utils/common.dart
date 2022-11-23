import 'package:intl/intl.dart';

getViews(String? viewCount) {
  if (viewCount == null) return;
  if (viewCount.length < 5) {
    return viewCount;
  } else if (viewCount.length == 5) {
    return "${viewCount.substring(0, 2)}K";
  } else if (viewCount.length == 6) {
    return "${viewCount.substring(0, 3)}K";
  } else if (viewCount.length == 7) {
    return "${viewCount.substring(0, 1)}M";
  } else if (viewCount.length == 8) {
    return "${viewCount.substring(0, 2)}M";
  } else if (viewCount.length == 9) {
    return "${viewCount.substring(0, 3)}M";
  }
}

getDateFormat(String? date) {
  if (date == null) return;
  var currentDate = DateTime.now();
  var difference = currentDate.difference(DateTime.parse(date));

  if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 365) {
    final DateFormat formatter = DateFormat('MMMM-dd');
    return formatter.format(DateTime.parse(date));
  } else if (difference.inDays > 365) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.parse(date));
  }
}
