import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';

class UserReportController extends GetxController {
  RxBool sort = true.obs;
  RxInt totalDoc = 0.obs;
  RxInt documentLimit = 25.obs;
  final Query<Map<String, dynamic>> reportsList = queryCollectionDB('Reports').orderBy("timestamp",descending: true);
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getReportedUser() async {
    List itemList = [];
    try {
      // ignore: non_constant_identifier_names
      var result = await reportsList.get();
      result.docs.forEach((element) {
        itemList.add(element.data());
      });
      return itemList;
    } catch (e) {
      print("getReportedUser=====>${e.toString()}");
      return [];
    }
  }
}
