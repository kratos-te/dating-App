import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showPicture(String? name, DateTime? date, String imageUrl) {
  ArtSweetAlert.show(
    context: Get.context!,
    artDialogArgs: ArtDialogArgs(
      title: name,
      text: date?.toLocal().toIso8601String(),
      customColumns: [
        Container(
          margin: EdgeInsets.only(bottom: 12.0),
          child: Image.network(
            imageUrl,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                "assets/images/empty.png",
              );
            },
          ),
        )
      ],
    ),
  );
}
