import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';

import '../../infrastructure/dal/util/general.dart';
import 'controllers/itemaccess.controller.dart';

class ItemaccessScreen extends GetView<ItemaccessController> {
  ItemaccessScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Get.put(ItemaccessController()); 
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Subscription settings",
      //     style: TextStyle(
      //       fontWeight: FontWeight.w300,
      //       fontSize: 25,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (Get.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Obx(
            () => controller.isLoading.value
                ? loadingWidget(null, null)
                : Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Text("Subscription settings",style: TextStyle(fontSize: 20),),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: !controller.edit.value
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  controller.edit.value = true;
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  controller.edit.value = false;
                                },
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: controller.edit.value
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState?.validate() ==
                                      true) {
                                    formKey.currentState?.save();
                                    if (kDebugMode) {
                                      print(controller.data);
                                    }
                                    controller.edit.value = false;
                                    await queryCollectionDB("Item_access")
                                        .doc('free-paid')
                                        .set(
                                          controller.data,
                                          SetOptions(merge: true),
                                        );
                                    await controller.getAccessItems();
                                    Global()
                                        .showInfoDialog("Updated Sucessfully");
                                  }
                                },
                              )
                            : Container(),
                      ),
                      Padding(
                        padding: isLargeScreen
                            ? EdgeInsets.all(48.0)
                            : EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: controller.edit.value
                                          ? TextFormField(
                                              controller: controller.freeRctlr,
                                              validator: (value) {
                                                if ((value ?? "").isEmpty) {
                                                  return 'Please enter this field';
                                                } else if (!Global()
                                                    .isNumeric(value)) {
                                                  return 'Enter an integar value';
                                                }
                                                return null;
                                              },
                                              autofocus: false,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              decoration: InputDecoration(
                                                helperText:
                                                    "this is how it will appear in app",
                                                labelText: "Free Radius(Kms.)",
                                                hintText: "Free Radius(Kms.)",
                                              ),
                                              onSaved: (value) {
                                                controller.data['free_radius'] =
                                                    value;
                                              },
                                            )
                                          : Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ListTile(
                                                dense: !isLargeScreen,
                                                leading: Icon(
                                                  Icons.location_searching,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Free radius access(in kms.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  "${(controller.freeRctlr?.text ?? "").isNotEmpty ? controller.freeRctlr?.text : "-----"} km",
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: isLargeScreen
                                          ? Get.width * .1
                                          : Get.width * .01,
                                    ),
                                    Expanded(
                                      child: controller.edit.value
                                          ? TextFormField(
                                              controller: controller.paidRctlr,
                                              validator: (value) {
                                                if ((value ?? "").isEmpty) {
                                                  return 'Please enter this field';
                                                } else if (!Global()
                                                    .isNumeric(value)) {
                                                  return 'Enter an integar value';
                                                }
                                                return null;
                                              },
                                              autofocus: false,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              decoration: InputDecoration(
                                                helperText:
                                                    "this is how it will appear in app",
                                                labelText: "Paid Radius(Kms.)",
                                                hintText: "Paid Radius(Kms.)",
                                              ),
                                              onSaved: (value) {
                                                controller.data['paid_radius'] =
                                                    value;
                                              },
                                            )
                                          : Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 5,
                                              child: ListTile(
                                                dense: !isLargeScreen,
                                                leading: Icon(
                                                  Icons.location_searching,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Paid radius access(in kms.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                    "${(controller.paidRctlr?.text ?? "").isNotEmpty ? controller.paidRctlr?.text : "-----"} km"),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: controller.edit.value
                                          ? TextFormField(
                                              controller:
                                                  controller.freeSwipectlr,
                                              validator: (value) {
                                                if ((value ?? "").isEmpty) {
                                                  return 'Please enter this field';
                                                } else if (!Global()
                                                    .isNumeric(value)) {
                                                  return 'Enter an integar value';
                                                }
                                                return null;
                                              },
                                              autofocus: false,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              decoration: InputDecoration(
                                                helperText:
                                                    "this is how it will appear in app",
                                                labelText: "Free Swipes",
                                                hintText: "Free Swipes",
                                              ),
                                              onSaved: (value) {
                                                controller.data['free_swipes'] =
                                                    value;
                                              },
                                            )
                                          : Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 5,
                                              child: ListTile(
                                                dense: !isLargeScreen,
                                                leading: Icon(
                                                  Icons.filter_none,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Free swipes(in 24hrs.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  "${(controller.freeSwipectlr?.text ?? "").isNotEmpty ? controller.freeSwipectlr?.text : "-----"}" +
                                                      ' swipes/24hrs.',
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: isLargeScreen
                                          ? Get.width * .1
                                          : Get.width * .01,
                                    ),
                                    Expanded(
                                      child: controller.edit.value
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    controller.paidSwipectlr,
                                                readOnly: true,
                                                autofocus: false,
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                decoration: InputDecoration(
                                                  helperText:
                                                      "this is how it will appear in app",
                                                  hintText:
                                                      "Unlimited(if paid user)",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            )
                                          : Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 5,
                                              child: ListTile(
                                                dense: !isLargeScreen,
                                                leading: Icon(
                                                  Icons.filter_none,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Paid Swipes",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text("Unlimited"),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
