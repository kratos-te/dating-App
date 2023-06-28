import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unjabbed_admin/presentation/package/controllers/package.controller.dart';

class CreatePackageWidget extends GetView<PackageController> {
  const CreatePackageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  controller.edit
                      ? "Edit subscription"
                      : "Add new subscription",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context, null),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  controller.edit ? "Save Changes" : "SAVE",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  controller.editPackage();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 20, right: 100),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  dense: true,
                  leading: Checkbox(
                    value: controller.active.value,
                    tristate: true,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) {
                      controller.active.value = !controller.active.value;
                    },
                  ),
                  title: Text("Activate"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: controller.titlectlr,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      helperText: "this is how it will appear in app",
                      labelText: "Title",
                      hintText: "Title",
                    ),
                    onChanged: (value) {
                      controller.data['title'] = value;
                    },
                  ),
                  TextFormField(
                    controller: controller.idctlr,
                    readOnly: controller.edit,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      helperText:
                          "it should match with play console product id",
                      labelText: "Product id",
                      hintText: "Product id",
                    ),
                    onChanged: (value) {
                      controller.data['id'] = value;
                    },
                  ),
                  TextFormField(
                    controller: controller.descctlr,
                    minLines: 2,
                    autofocus: false,
                    cursorColor: Theme.of(context).primaryColor,
                    maxLines: 5,
                    decoration: InputDecoration(
                      helperText: "this is how it will appear in app",
                      labelText: "Description",
                      hintText: "Description",
                    ),
                    onChanged: (value) {
                      controller.data['description'] = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
