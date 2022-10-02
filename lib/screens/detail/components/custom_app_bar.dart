import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(50),
              padding: const EdgeInsets.only(left: 9.0),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                tooltip: 'Back',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
