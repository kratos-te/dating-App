import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/core/interfaces/widget/loading.dart';
import '../../../domain/core/interfaces/widget/showImage.dart';
import '../../../domain/core/model/ReviewModel.dart';
import '../../../infrastructure/dal/util/Global.dart';
import '../../../infrastructure/dal/util/general.dart';
import '../../../infrastructure/navigation/routes.dart';
import 'controllers/user_review.controller.dart';

class UserReviewScreen extends GetView<UserReviewController> {
  const UserReviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(UserReviewController());
    return WillPopScope(
      onWillPop: (() async {
        Get.offAllNamed(Routes.USER);
        return await true;
      }),
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (Get.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Scaffold(
            // appBar: AppBar(
            //   leading: IconButton(
            //     onPressed: () {
            //       Get.offAllNamed(Routes.USER);
            //     },
            //     icon: Icon(Icons.arrow_back_ios_new),
            //   ),
            //   centerTitle: true,
            //   title: Text(
            //     "Review Users",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   actions: [
                
            //   ],
            // ),
            body: !controller.isLoading.value
                ? Column(
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Review Users",style: TextStyle(fontSize: 20),),
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
                ),
                      ],
                    ),
                    Expanded(child: listReviewWidget()),
                  ],
                )
                : loadingWidget(null, null),
          );
        },
      ),
    );
  }

  Widget listReviewWidget() {
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
                  showBottomBorder: true,
                  sortAscending: controller.sort.value,
                  sortColumnIndex: 2,
                  dataRowHeight: 200,
                  // columnSpacing: 0,
                  // horizontalMargin: 0,
                  columns: [
                    DataColumn(
                      label: Text("Number"),
                    ),
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Status"),
                    ),
                    DataColumn(
                      label: Text("Reason"),
                    ),
                    DataColumn(label: Text("Picture")),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  rows: controller.listReview
                      .map(
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                (controller.listReview.indexOf(index) + 1)
                                    .toString(),
                              ),
                            ),
                            DataCell(
                              Text(index.name ?? ""),
                            ),
                            DataCell(
                              Text(
                                (index.status?.value ?? "").capitalizeFirst ??
                                    "",
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 400,
                                child: Text(
                                  index.reason?.value ?? "",
                                ),
                              ),
                            ),
                            if ((index.listImage ?? []).isEmpty)
                              DataCell(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CircleAvatar(
                                    child: Image.asset(
                                      "assets/images/empty.png",
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
                              ),
                            if ((index.listImage ?? []).isNotEmpty)
                              DataCell(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CircleAvatar(
                                    child: Image.network(
                                      index.listImage?.last?.imageUrl ?? "",
                                      fit: BoxFit.fill,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                          "assets/images/empty.png",
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                    backgroundColor: Colors.grey,
                                    radius: 18,
                                  ),
                                ),
                                onTap: () {
                                  showPicture(
                                    index.name,
                                    index.listImage?.last?.createdAt,
                                    index.listImage?.last?.imageUrl ?? "",
                                  );
                                },
                              ),
                            DataCell(
                              StatusWidget(index),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 12,
                      ),
                      onPressed: () {
                        if (!controller.isSearch.value) {
                          controller.initReview(add: false);
                          return;
                        }
                        controller.addReviewSearch(
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
                        controller.initReview(add: true);
                        return;
                      }
                      controller.addReviewSearch(
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

  StatusWidget(ReviewModel suspendModel) {
    print(suspendModel.status?.value);
    return Obx(() {
      if (suspendModel.status?.value == "suspend") {
        return InkWell(
          onTap: () {
            controller.valueTitle=null;
            // controller.rea
            controller.updateSuspendWidget("unsuspend", suspendModel);
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
              "Unsuspend",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      if (suspendModel.status?.value == "review") {
        return InkWell(
          onTap: () {
            controller.updateReviewWidget("review", suspendModel);
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
              "Waiting for Action",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      if (suspendModel.status?.value == "unsuspend") {
        return InkWell(
          onTap: () {
            controller.updateSuspendWidget("suspend", suspendModel);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              "Suspend",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      return Container();
    });
  }
}
