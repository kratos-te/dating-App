import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/domain/core/interfaces/widget/loading.dart';
import 'package:unjabbed_admin/presentation/verify/controllers/verify.controller.dart';

import '../../domain/core/interfaces/widget/drawer.dart';
import '../../domain/core/interfaces/widget/showImage.dart';
import '../../infrastructure/dal/util/Global.dart';
import '../../infrastructure/dal/util/general.dart';

class VerifyScreen extends GetView<VerifyController> {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyController());
    return OrientationBuilder(
      builder: (context, orientation) {
        if (Get.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        return Scaffold(
          // drawer: drawer(context),
          body: !controller.isLoading.value
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Verify Users",style: TextStyle(fontSize: 20),),
                      ),
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 50,
                        width: isLargeScreen ? Get.width * .3 : Get.width * .5,
                        child: Card(
                          child: TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: controller.searchctrlr,
                            decoration: InputDecoration(
                              hintText: "Search by name or phone number",
                              filled: true,
                              prefixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () => controller.searchFirstVerify(
                                  controller.searchctrlr?.text ?? "",
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  controller.searchctrlr?.clear();
                                  controller.searchFirstVerify("");
                                },
                              ),
                            ),
                            onFieldSubmitted: controller.searchFirstVerify,
                          ),
                        ),
                      ),
                    )
                    ],
                  ),
                  Expanded(
                    child: listVerifyUserWidget()),
                ],
              )
              : loadingWidget(null, null),
        );
      },
    );
  }

  Widget listVerifyUserWidget() {
    // print(controller.listVerify[0].codeVerify);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Obx(
        () => Column(
          children: [
            Container(
              width: Get.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: controller.sort.value,
                  sortColumnIndex: 2,
                  columnSpacing: Get.width * .085,
                  columns: [
                    DataColumn(
                      label: Text("Number"),
                    ),
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(label: Text("Verification Code")),
                    DataColumn(label: Text("Picture")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: controller.listVerify
                      .map(
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text((controller.listVerify.indexOf(index) + 1)
                                  .toString()),
                            ),
                            DataCell(
                              Text(index.name),
                            ),
                            DataCell(
                              Text(index.codeVerify),
                            ),
                            DataCell(
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CircleAvatar(
                                  child: Image.network(
                                    index.imageUrl,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Text('');
                                    },
                                  ),
                                  backgroundColor: Colors.grey,
                                  radius: 18,
                                ),
                              ),
                              onTap: () {
                                showPicture(index.name, index.dateUpdated,
                                    index.imageUrl);
                              },
                            ),
                            DataCell(
                              Row(
                                children: [
                                  if (index.verified == 1)
                                    InkWell(
                                      onTap: () {
                                        controller.acceptDialog(index.idUser);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (index.verified == 1) SizedBox(width: 10),
                                  if (index.verified == 1)
                                    InkWell(
                                      onTap: () {
                                        controller.rejectDialog(index.idUser);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (index.verified == 2)
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        "Rejected",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (index.verified == 3)
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        "Accepted",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
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
                          controller.initVerify(addUser: false);
                          return;
                        }
                        controller.addVerifySearch(
                            controller.searchctrlr?.text ?? "", false);
                      }),
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
                        controller.initVerify(addUser: true);
                        return;
                      }
                      controller.addVerifySearch(
                        controller.searchctrlr?.text ?? '',
                        true,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
