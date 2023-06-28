import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../infrastructure/dal/util/Global.dart';
import '../../../../infrastructure/dal/util/color.dart';

Widget loadingWidget(double? height, BorderRadius? borderRadius,
    {bool isloadingText = false}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        customLoadingWidget(
          text: (isloadingText) ? "Loading ...." : "",
          color: primaryColor,
        ),
      ],
    ),
  );
}

Widget customLoadingWidget({String text = "", Color color = Colors.blue}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipOval(
        child: SpinKitDoubleBounce(
          color: color,
          // size: 50.0,
        ),
      ),
      if (text.isNotEmpty)
        SizedBox(
          height: 15,
        ),
      if (text.isNotEmpty)
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16,
            // fontFamily: Global.font,
          ),
        )
    ],
  );
}
