import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/domain/core/model/CustomDuration.dart';
import '../../domain/core/interfaces/widget/drawer.dart';
import '../../domain/core/show_alert.dart';
import '../../infrastructure/dal/util/Global.dart';
import '../../infrastructure/dal/util/general.dart';
import 'controllers/user.controller.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return OrientationBuilder(builder: (context, orientation) {
      if (Get.width > 600) {
        isLargeScreen = true;
      } else {
        isLargeScreen = false;
      }
      return Obx(
        () => Scaffold(
          drawer: drawer(context,controller.controller),
          body: !controller.isLoading.value ? listUserWidget() : loadingWidget(null, null),
        ),
      );
    });
  }

  Widget listUserWidget() {
    print("Jumlah User : " + controller.listUser.length.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              return Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16,
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
                        "Create New Broadcast",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        controller.valueTitle=null;
                        controller.title?.text='';
                        controller.content?.text='';
                        controller.createBroadcastDialog(Get.context!);
                      },
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: DropdownButtonFormField<CustomDuration>(
                        elevation: 11,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 25,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Name",
                          fillColor: Colors.white,
                        ),
                        value: controller.selectedDay.value,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          controller.selectedDay.value = value;
                          controller.searchFirstUser(controller.searchController?.text ?? "");
                        },
                        items: listCustomDay
                            .map(
                              (content) => DropdownMenuItem(
                                value: content,
                                child: Text(
                                  "${content.name}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: DropdownButtonFormField<int>(
                        elevation: 11,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 12,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Name",
                          fillColor: Colors.white,
                        ),
                        value: controller.documentLimit.value,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          controller.documentLimit.value = value;
                          controller.searchFirstUser(controller.searchController?.text ?? "");
                        },
                        items: listLimitPagination
                            .map(
                              (content) => DropdownMenuItem(
                                value: content,
                                child: Text(
                                  "${content}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 50,
                  width: isLargeScreen ? Get.width * .3 : Get.width * .5,
                  child: Card(
                    child: TextFormField(
                      cursorColor: Theme.of(Get.context!).primaryColor,
                      controller: controller.searchController,
                      decoration: InputDecoration(
                          hintText: "Search by name or phone number",
                          filled: true,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => controller.searchFirstUser(
                              (controller.searchController?.text ?? ""),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              controller.searchController?.clear();
                              controller.searchFirstUser("");
                            },
                          )),
                      onFieldSubmitted: (String value) {
                        controller.searchFirstUser(
                          value,
                        );
                      },
                    ),
                  ),
                ),
              ),
                  ],
                ),
              );
            },
          ),
          Container(
            width: Get.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 150,
                sortAscending: controller.sort.value,
                sortColumnIndex: 2,
                columnSpacing: Get.width * .085,
                columns: [
                  DataColumn(
                    label: Text("Images"),
                  ),
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Gender"),
                    onSort: (columnIndex, ascending) {
                      controller.sort.value = !controller.sort.value;
                      controller.onSortColum(columnIndex, ascending);
                    },
                  ),
                  DataColumn(label: Text("Country")),
                  DataColumn(label: Text("Created at")),
                  DataColumn(label: Text("view")),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: controller.listUser.map(
                  (index) {
                    debugPrint("user Image url ${index.imageUrl[0]['url']}");

                    return DataRow(
                      cells: [
                                DataCell(
                            SizedBox(
                              height: 140,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CircleAvatar(
                                  child: index.imageUrl[0] != null
                                      ? Image.network(
                                          // (index.imageUrl[0].runtimeType ==
                                          //         String)
                                          //     ? index.imageUrl[0]
                                          //     : index.imageUrl[0]['url'],
                                    index.imageUrl[0]['url'],
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Text('');
                                          },
                                        )
                                      : Container(),
                                  backgroundColor: Colors.grey,
                                  radius: 18,
                                ),
                              ),
                            ),
                            onTap: () {
                              ShowAlert.image(Get.context!, image: index.imageUrl[0]['url']);
                              // Get.find<UserController>()
                              //     .initDetailUser(userIndex: index);
                              // print("Test");
                              // write your code..
                            },
                          ),
                       /* DataCell(
                          SizedBox(
                            height: 140,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CachedNetworkImage(
                                imageUrl: index.imageUrl[0]['url'],
                                fit: BoxFit.cover,
                                useOldImageOnUrlChange: true,

                                placeholder: (context, url) => CupertinoActivityIndicator(
                                  radius: 20,
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        DataCell(
                          Text(index.name),
                        ),
                        DataCell(
                          Text(index.gender),
                        ),
                        DataCell(
                          Text(index.countryName),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  DateFormat.MMMd('en_US').add_jm().format(index.createdAt ?? DateTime.now()).toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.content_copy,
                                  size: 20,
                                ),
                                tooltip: "copy",
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: index.id,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.fullscreen),
                            tooltip: "open profile",
                            onPressed: () async {
                              controller.initDetailUser(userIndex: index);
                            },
                          ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () {
                              Global().createSuspendUser(index);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Action",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                  ),
                  onPressed: () {
                    if (!controller.isSearch.value) {
                      controller.initUser(addUser: false);
                      return;
                    }
                    controller.addUserSearch((controller.searchController?.text ?? ""), false);
                  },
                ),
                if (!controller.isSearch.value)
                  Text(
                      "${(controller.start.value + 1)}-${Global().checkLast(controller.end.value, controller.totalDoc.value)} of ${controller.totalDoc.value}"),
                if (controller.isSearch.value)
                  Text(
                      "${(controller.start.value + 1)}-${Global().checkLast(controller.end.value, controller.totalDocSearch.value)} of ${controller.totalDocSearch.value}"),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                  onPressed: () {
                    if (!controller.isSearch.value) {
                      controller.initUser(addUser: true);
                      return;
                    }
                    controller.addUserSearch((controller.searchController?.text ?? ""), true);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchresults() {
    return Obx(
      () {
        if (controller.listUser.length > 0) {
          return listUserWidget();
        }
        return Center(child: Text("no data found"));
      },
    );
  }
}
