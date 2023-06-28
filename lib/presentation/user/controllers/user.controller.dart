import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/domain/core/model/CustomDuration.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/color.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';
import '../../../domain/core/model/user_model.dart';
import '../../../infrastructure/dal/services/fcm_service.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../detail/custom_dropdown_widget.dart';
import '../detail/vinculo_model.dart';

class UserController extends GetxController {
  RxList<UserModel> listUserAll = RxList();
  RxList<UserModel> listUserSearchAll = RxList();
  RxList<UserModel> listUser = RxList();
  TextEditingController? searchController;
  final PageController controller=PageController();
  TextEditingController? title;
  TextEditingController? content;
  RxInt documentLimit = 25.obs;
  RxInt totalDoc = 0.obs;
  Vinculo? valueTitle;
  RxInt totalDocSearch = 0.obs;
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxBool sort = false.obs;
  String tempQuery = "";
  Rxn<UserModel> selectedUser = Rxn();
  RxInt start = 0.obs;
  RxInt end = 0.obs;
  Rxn<CustomDuration> selectedDay = Rxn();
  List<MultiSelectItem<UserModel>> listItemMulti = [];
  List<String> listTabs = ['all', "multiple"];

  initDetailUser({required UserModel userIndex}) async {
    selectedUser.value = userIndex;
    var isdelete = await Get.toNamed(
      Routes.USER_DETAIL + "/${userIndex.id}",
    );
    if (isdelete != null && isdelete) {
      Global().showInfoDialog("Deleted");
      listUserAll.removeWhere((element) => element.id == userIndex.id);
      listUser.removeWhere((element) => element.id == userIndex.id);
      listUser.sort((a, b) => (b.createdAt??DateTime.now()).compareTo(a.createdAt??DateTime.now()));
      if (isSearch.value) {
        listUserSearchAll.removeWhere((element) => element.id == userIndex.id);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedDay.value = listCustomDay.first;
    initAll();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // searchController?.dispose();
    // title?.dispose();
    // content?.dispose();
  }

  initAll() async {
    isLoading.value = true;
    if (searchController == null) {
      title = TextEditingController();
      content = TextEditingController();
      searchController = TextEditingController();
    }
    var listDoc = await queryCollectionDB("Users")
        .orderBy("user_DOB", descending: true)
        // .limit(50)
        .get();
    if (listDoc.docs.isNotEmpty) {
      totalDoc.value = listDoc.docs.length;
      for (var doc in listDoc.docs) {
        var temp = UserModel.fromJson(doc.data());
        Timestamp timeStamp = doc.data()['timestamp'];
        // if (kDebugMode) {
        //   print(doc.data()['timestamp'].runtimeType);
        // }
        temp.createdAt = timeStamp.toDate();
        listUserAll.add(temp);
      }
      initUser(addUser: true, firstInit: true);
      listItemMulti = listUserAll
          .map((animal) => MultiSelectItem<UserModel>(animal, animal.name))
          .toList();
    }
    isLoading.value = false;
  }

  initUser({required bool addUser, bool firstInit = false}) async {
    if (listUserAll.isEmpty) {
      return;
    }
    if (addUser && end.value == totalDoc.value) {
      return;
    }
    if (!addUser && start.value == 0) {
      return;
    }
    isLoading.value = true;
    if (firstInit) {
      start.value = 0;
      end.value = 0;
    }
    if (addUser) {
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDoc.value - 1)) {
        end.value = totalDoc.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
    } else {
      end.value = start.value;
      if ((start.value - documentLimit.value) < 0) {
        start.value = 0;
      } else {
        start.value = start.value - documentLimit.value;
      }
    }
    listUserAll.sort((a, b) => (b.createdAt??DateTime.now()).compareTo(a.createdAt??DateTime.now()));
    listUser.assignAll(
      Global()
          .filterPagination(start.value, end.value, listUserAll)
          .toList()
          .map((e) => e as UserModel),
    );
     
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  bool checkSearchUser(UserModel userModel, String query, bool isNumber) {
    if (isNumber && userModel.phoneNumber.contains(query)) {
      return true;
    }
    if (!isNumber &&
        userModel.name.toLowerCase().contains(query.toLowerCase())) {
      return true;
    }
    return false;
  }

  searchFirstUser(String query) async {
    if (query.trim().length > 0 || selectedDay.value?.type != "all") {
      isLoading.value = true;
      tempQuery = query;
      bool isNumber = Global().isNumeric(query);
      getCountSearch(query, isNumber);
      if (listUserSearchAll.isEmpty) {
        return;
      }
      end.value = 0;
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDocSearch.value - 1)) {
        end.value = totalDocSearch.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
      listUser.assignAll(
        Global()
            .filterPagination(start.value, end.value, listUserSearchAll)
            .toList()
            .map((e) => e as UserModel),
      );
       listUser.sort((a, b) => (b.createdAt??DateTime.now()).compareTo(a.createdAt??DateTime.now()));
      isSearch.value = true;
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      return;
    }
    isSearch.value = false;
    initUser(addUser: true, firstInit: true);
  }

  getCountSearch(String query, bool isNumber) {
    listUserSearchAll.value = listUserAll.where((element) {
      return (checkSearchUser(element, query, isNumber) &&
          Global().cekDate(element, selectedDay.value!));
    }).toList();
    totalDocSearch.value = listUserSearchAll.length;
  }

  addUserSearch(String query, bool addUser) {
    if (listUserSearchAll.isEmpty) {
      return;
    }
    if (addUser && end.value == totalDocSearch.value) {
      return;
    }
    if (!addUser && start.value == 0) {
      return;
    }
    if (addUser) {
      start.value = end.value;
      if ((end.value + documentLimit.value) >= (totalDocSearch.value - 1)) {
        end.value = totalDocSearch.value;
      } else {
        end.value = end.value + documentLimit.value;
      }
    } else {
      end.value = start.value;
      if ((start.value - documentLimit.value) < 0) {
        start.value = 0;
      } else {
        start.value = start.value - documentLimit.value;
      }
    }
    listUser.sort((a, b) => (b.createdAt??DateTime.now()).compareTo(a.createdAt??DateTime.now()));
    listUser.assignAll(Global()
        .filterPagination(start.value, end.value, listUserSearchAll)
        .toList()
        .map((e) => e as UserModel));
         

    ;
  }

  sendtoSpesificUser() async {
    if ((title?.text ?? '').isEmpty) {
      Get.snackbar("Information", "Please field title first");
      return;
    }
    // isLoading.value = true;
    try {
      String toParams = "/topics/" + (selectedUser.value?.id ?? "");
      var data = {"title": (title?.text ?? ""), "body": (content?.text ?? "")};
      var response = await FCMService().sendFCM(data: data, to: toParams);
      // print(response);
      if (response) {
        title?.text = "";
        content?.text = "";
        Global().showInfoDialog("Success Send Broadcast");
      } else {
        if (kDebugMode) {
          print(response);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error : " + e.toString());
      }
    }
    // isLoading.value = false;
  }

  sendtoFewUsers(List<UserModel> listTempUser) async {
    if ((title?.text ?? '').isEmpty) {
      Get.snackbar("Information", "Please field title first");
      return;
    }
    if (listTempUser.isEmpty) {
      Get.snackbar("Information", "Please select user first");
      return;
    }
    // isLoading.value = true;
    try {
      for (var user in listTempUser) {
        String toParams = "/topics/" + (user.id);
        var data = {
          "title": (title?.text ?? ""),
          "body": (content?.text ?? "")
        };
        FCMService().sendFCM(data: data, to: toParams);
      }
      Global().showInfoDialog("Success Send Broadcast");
    } catch (e) {
      if (kDebugMode) {
        print("Error : " + e.toString());
      }
    }
    // isLoading.value = false;
  }

  sendtoAllUser() async {
    if ((title?.text ?? "").isEmpty) {
      Get.snackbar("Information", "Please field title first");
      return;
    }
    isLoading.value = true;
    try {
      String toParams = "/topics/" + "all";
      var data = {"title": (title?.text ?? ""), "body": (content?.text ?? "")};
      var response = await FCMService().sendFCM(data: data, to: toParams);
      // print(response);
      if (response) {
        if (kDebugMode) {
          print("Success Send FCM");
        }
        title?.text = "";
        content?.text = "";
        Global().showInfoDialog("Success Send Broadcast");
      } else {
        if (kDebugMode) {
          print(response);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error : " + e.toString());
      }
      Global().showInfoDialog(e.toString());
    }
    isLoading.value = false;
  }

  createBroadcastDialog(BuildContext context) {
    RxString selectedTabs = "all".obs;
    RxList<UserModel> listSelectedUser = RxList();
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 450),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: a1,
                  curve: const ElasticOutCurve(.8),
                  reverseCurve: Curves.easeInCubic)),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: a1, curve: Curves.easeOutBack, reverseCurve: Curves.easeInCubic)),
            child: widget),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black26,
            width: double.infinity,height: double.infinity,),
        ),
            Align(
                    alignment: Alignment.center,
                  child: Material(
              color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width*.5,
                      height: MediaQuery.of(context).size.height*.7,
                                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var contentTabs in listTabs)
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  selectedTabs.value = contentTabs;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedTabs.value == contentTabs
                                        ? primaryColor
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.red[500]!,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    contentTabs.capitalizeFirst ?? "",
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 15),
                      multipleChoiceUserWidget(selectedTabs, listSelectedUser),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            "Title",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      CustomDropDownWidget(
                        withSearch: true,
                        // valueVinculo: true,
                        title: 'Title',
                        maxLines: null,
                        value: valueTitle,
                        onChange: (Vinculo value){
                          valueTitle=value;
                          content?.text=value.value;
                          update();
                        },
                        textEditingController: title!,
                        lista: vinculoList,
                      ),
                      // TextField(
                      //   controller: title,
                      //   style: TextStyle(fontSize: 20),
                      //   maxLines: 1,
                      //   decoration: new InputDecoration(
                      //     border: new OutlineInputBorder(
                      //         borderSide: new BorderSide(color: Colors.teal)),
                      //     hintText: 'Title',
                      //     prefixIcon: const Icon(
                      //       Icons.title,
                      //       color: Colors.green,
                      //     ),
                      //     prefixText: ' ',
                      //     // suffixText: 'USD',
                      //     suffixStyle: const TextStyle(color: Colors.green),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Message",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextField(
                        controller: content,
                        style: TextStyle(fontSize: 20),
                        maxLines: 4,
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: '',
                          prefixIcon: const Icon(
                            Icons.subtitles,
                            color: Colors.green,
                          ),
                          prefixText: ' ',
                          suffixStyle: const TextStyle(color: Colors.green),
                        ),
                      ),
                      SizedBox(height: 15),
                      Obx(
                        () {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(30.0),
                            child: isLoading.value
                                ? loadingWidget(null, null)
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      foregroundColor:
                                          Theme.of(Get.context!).primaryColor,
                                      elevation: 11,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(40.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Send",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (selectedTabs.value != "all") {
                                        sendtoFewUsers(listSelectedUser);
                                        return;
                                      }
                                      sendtoAllUser();
                                    },
                                  ),
                          );
                        },
                      ),
                    ],
                                  ),
                                ),
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget multipleChoiceUserWidget(
      RxString selectedTabs, RxList<UserModel> listSelectedUser) {
    return Obx(() {
      if (selectedTabs.value == "multiple") {
        return Column(
          children: [
            SizedBox(height: 10),
            MultiSelectDialogField(
              searchable: true,
              items: listItemMulti,
              title: Text("Users"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              buttonIcon: Icon(
                Icons.search,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Choice User",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                listSelectedUser.assignAll(results);
              },
              initialValue: listSelectedUser,
              chipDisplay: MultiSelectChipDisplay<UserModel>(
                icon: Icon(Icons.close_sharp),
                onTap: (UserModel? value) {
                  if (kDebugMode) {
                    print(value);
                  }
                  if (value == null) {
                    return;
                  }
                  listSelectedUser.remove(value);
                },
              ),
            ),
          ],
        );
      }
      return Container();
    });
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 2) {
      if (ascending) {
        listUser.sort((a, b) => a.gender.compareTo(b.gender));
      } else {
        listUser.sort((a, b) => b.gender.compareTo(a.gender));
      }
    }
  }
}
