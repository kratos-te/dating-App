import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/model/user_model.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/presentation/user/detail/vinculo_model.dart';

import '../../../domain/core/interfaces/widget/alert.dart';
import '../../../domain/core/interfaces/widget/loading.dart';
import '../../../domain/core/show_alert.dart';
import '../../../infrastructure/dal/util/general.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../controllers/user.controller.dart';
import 'controllers/user_detail.controller.dart';
import 'custom_dropdown_widget.dart';

class UserDetailScreen extends GetView<UserDetailController> {
  const UserDetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(UserDetailController());
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (Get.isRegistered<UserController>()) {
            Get.back();
            return Future.value(false);
          }
          Get.toNamed(Routes.USER);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (Get.isRegistered<UserController>()) {
                  Get.back();
                  return;
                }
                Get.toNamed(Routes.USER);
              },
            ),
            centerTitle: true,
            title: Text("${controller.selectedUser.value?.name ?? ""}"),
            actions: [
              PopupMenuButton(onSelected: (value) {
                if (value == 1) {
                  // Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BeautifulAlertDialog(
                        text:
                            "Do you want to ${controller.selectedUser.value?.isBlocked?.value == true ? "Unblock" : "Block"} ${controller.selectedUser.value?.name} ?",
                        onYesTap: () async {
                          await queryCollectionDB("Users")
                              .doc(controller.selectedUser.value?.id)
                              .set(
                            {
                              "isBlocked": controller
                                      .selectedUser.value?.isBlocked?.value ==
                                  false,
                            },
                            SetOptions(merge: true),
                          ).whenComplete(() {
                            Global().showInfoDialog(
                                "${controller.selectedUser.value?.isBlocked?.value == false ? "Blocked" : "Unblocked"}");
                            controller.selectedUser.value?.isBlocked?.value =
                                !(controller
                                        .selectedUser.value?.isBlocked?.value ??
                                    false);
                          });
                          Navigator.pop(context);
                        },
                        onNoTap: () => Navigator.pop(context),
                      );
                    },
                  );
                }
                if (value == 2) {
                  // Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BeautifulAlertDialog(
                        text:
                            "Do you want to delete ${controller.selectedUser.value?.name}'s profile ?",
                        onYesTap: () async {
                          await queryCollectionDB("Users")
                              .doc(controller.selectedUser.value?.id)
                              .delete()
                              .whenComplete(() async {
                            Navigator.pop(context, true);
                          });
                          Navigator.pop(context, true);
                        },
                        onNoTap: () => Navigator.pop(context),
                      );
                    },
                  );
                }
              }, itemBuilder: (ct) {
                return [
                  PopupMenuItem(
                    enabled: true,
                    height: 25,
                    value: 1,
                    child: InkWell(
                      child: Text(
                          "${controller.selectedUser.value?.isBlocked?.value == true ? "Unblock user" : "Block user"}"),
                    ),
                  ),
                  PopupMenuItem(
                    enabled: true,
                    height: 25,
                    value: 2,
                    child: InkWell(
                      child: Text("Delete account"),
                    ),
                  )
                ];
              })
            ],
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              if (Get.width > 600) {
                isLargeScreen = true;
              } else {
                isLargeScreen = false;
              }
              return Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: loadingWidget(null, null),
                  );
                }
                return SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: isLargeScreen
                            ? const EdgeInsets.only(right: 50)
                            : EdgeInsets.all(1),
                        child: Container(
                          alignment: Alignment.center,
                          height: Get.height,
                          width:
                              isLargeScreen ? Get.width * .35 : Get.width * .45,
                          child: GridView.count(
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            //     MediaQuery.of(context).size.aspectRatio * .4,
                            crossAxisSpacing: 4,
                            padding: EdgeInsets.all(10),
                            children: List.generate(
                              9,
                              (index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: (controller.selectedUser.value
                                                              ?.imageUrl ??
                                                          [])
                                                      .length >
                                                  index &&
                                              controller.selectedUser.value
                                                      ?.imageUrl[index] !=
                                                  null
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                style: BorderStyle.solid,
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      child: Stack(
                                        children: <Widget>[
                                          (controller.selectedUser.value
                                                                  ?.imageUrl ??
                                                              [])
                                                          .length >
                                                      index &&
                                                  controller.selectedUser.value
                                                          ?.imageUrl[index] !=
                                                      null
                                              ? InkWell(
                                                onTap: (){
                                                  ShowAlert.image(Get.context!, image: (controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                          0]
                                                                      .runtimeType ==
                                                                  String)
                                                              ? controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                  index]
                                                              : controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                  index]['url']);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          (controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                          0]
                                                                      .runtimeType ==
                                                                  String)
                                                              ? controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                  index]
                                                              : controller
                                                                      .selectedUser
                                                                      .value
                                                                      ?.imageUrl[
                                                                  index]['url'],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text("Username"),
                              subtitle: Text(
                                  controller.selectedUser.value?.name ?? ""),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Gender"),
                              subtitle: Text(
                                  controller.selectedUser.value?.gender ?? ""),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Phone Number"),
                              subtitle: Text(
                                  controller.selectedUser.value?.phoneNumber ??
                                      ""),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("age"),
                              subtitle: Text(
                                  (controller.selectedUser.value?.age ?? 0)
                                      .toString()),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Maximum Distance"),
                              subtitle: Text(
                                  (controller.selectedUser.value?.maxDistance ??
                                          0)
                                      .toString()),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Age Range"),
                              subtitle: Text(
                                  (controller.selectedUser.value?.ageRange ??
                                          "")
                                      .toString()),
                            ),
                            sendWidget(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text("About"),
                              subtitle: Text(
                                controller.selectedUser.value
                                            ?.editInfo?["about"] !=
                                        null
                                    ? controller
                                        .selectedUser.value?.editInfo!["about"]
                                    : "----",
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Sexual Orientation"),
                              subtitle: Text(controller
                                  .selectedUser.value?.sexualOrientation??'--'),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("I am looking for"),
                              subtitle: Text(
                                controller.selectedUser.value?.interest.join(', ')??'---',
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Status"),
                              subtitle: Text(
                                controller.selectedUser.value?.status?? "----",
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Kink & desires"),
                              subtitle: Text(
                                '${controller.selectedUser.value?.kinks.join(', ')}${controller.selectedUser.value?.desires.join(', ')}',
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text("Address"),
                              subtitle: Text(
                                  controller.selectedUser.value?.address ?? ""),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget sendWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            value: controller.titleText,
            onChange: (Vinculo value){
              controller.titleText=value;
              controller.content?.text=value.value;
              controller.update();
            },
            textEditingController: controller.title!,
            lista: vinculoList,
          ),
          // TextField(
          //   controller: controller.title,
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
            controller: controller.content,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.0),
            child: controller.isLoadingBtn.value
                ? loadingWidget(null, null)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      foregroundColor: Theme.of(Get.context!).primaryColor,
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
                      controller.sendtoUsers(controller.selectedUser.value!);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
