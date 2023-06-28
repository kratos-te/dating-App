import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/Global.dart';
import 'package:unjabbed_admin/infrastructure/dal/util/general.dart';

import '../../domain/core/interfaces/widget/alert.dart';
import 'controllers/package.controller.dart';

class PackageScreen extends GetView<PackageController> {
  const PackageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PackageController());
    return Obx(
      () => Scaffold(
        body: controller.listPackages.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Manage Packages",style: TextStyle(fontSize: 20),),
                    ),
                    Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      textDirection: TextDirection.rtl,
                    ),
                    label: Text("Create new"),
                    onPressed: () async {
                      controller.initAddOrCreatePackage(null);
                    },
                  ),
                              ),
                            ),
                  ],
                ),
                Expanded(child: productlist()),
              ],
            )
            : Center(
                child: Image.asset("assets/images/empty.png"),
              ),
      ),
    );
  }

  Widget productlist() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Obx(
            () => Container(
              width: Get.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: Get.width * .08,
                  headingRowHeight: 40,
                  horizontalMargin: Get.width * .05,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Sr.No.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Product id",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Title",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      "Description",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Status",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Edit/Deactivate",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Remove",
                      textAlign: TextAlign.center,
                    )),
                  ],
                  rows: controller.listPackages
                      .mapIndexed(
                        (index, i) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                (i + 1).toString(),
                                //  products.indexOf(index).toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                index.id ?? "",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                index.title ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                index.description ?? "",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      index.status == true
                                          ? "Active"
                                          : "Deactivated",
                                      style: TextStyle(
                                        color: index.status == true
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  index.status == true
                                      ? Icon(
                                          Icons.done_outline,
                                          color: Colors.green,
                                          size: 13,
                                        )
                                      : Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 13,
                                        ),
                                ],
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  controller.initAddOrCreatePackage(index);
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: Get.context!,
                                    builder: (BuildContext context) {
                                      return BeautifulAlertDialog(
                                        text:
                                            "Do you want to delete this package ?",
                                        onYesTap: () async {
                                          await queryCollectionDB("Packages")
                                              .doc(index.id ?? "")
                                              .delete()
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          }).catchError((onError) {
                                            Global().showInfoDialog(
                                              onError.toString(),
                                            );
                                          }).then((value) {
                                            Global().showInfoDialog(
                                              "Deleted Successfully",
                                            );
                                            controller.getPackages();
                                          });
                                        },
                                        onNoTap: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
