import 'package:al_igtisam/models/channel_info.dart';
import 'package:al_igtisam/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/constants.dart';

class Body extends StatelessWidget {
  final ChannelInfo channelInfo;
  const Body({Key? key, required this.channelInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SocialMedia();
  }
}

class SocialMedia extends StatefulWidget {
  const SocialMedia({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(400),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset("assets/images/al igtisam.jpeg"),
          ),
        ),
        Row(
          children: [
            buildLinkContainer(instagramMobileUrl, instagramWebUrl,
                "assets/images/instagram_gif.gif"),
          ],
        )
      ],
    );
  }

  Widget buildLinkContainer(String mobileUrl, String webUrl, String iconPath) {
    return Container(
      // padding: EdgeInsets.all(getProportionateScreenHeight(1)),
      height: getProportionateScreenHeight(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () => _launcherInstagramUrl(mobileUrl, webUrl),
        icon: Image.asset(
          iconPath,
          height: getProportionateScreenHeight(30),
          width: getProportionateScreenWidth(30),
          fit: BoxFit.cover,
        ),
        // SvgPicture.asset(
        //   iconPath,
        //   fit: BoxFit.cover,
      ),
    );
  }

  _launcherInstagramUrl(String monileUrl, String webUrl) async {
    if (await canLaunchUrlString(monileUrl)) {
      await launchUrlString(monileUrl);
    } else if (await canLaunchUrlString(webUrl)) {
      await launchUrlString(webUrl);
    } else {
      throw "Could not launch $monileUrl and $webUrl";
    }
  }
}
