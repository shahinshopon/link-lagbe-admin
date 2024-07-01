import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:link_lagbe_update/const/custom_data_type.dart';
import 'package:link_lagbe_update/ui/style/style.dart';
import 'package:link_lagbe_update/widgets/custom_button.dart';
import 'package:link_lagbe_update/widgets/custom_textfield.dart';

class AllCategoryScreenController extends GetxController {
  // DocumentSnapshot? snapshotData;
  RxBool isLoading = false.obs;
  List<Map<String, String>> categories = [];
  RxString dropdownVal = "".obs;
  RxString docId = "".obs;
  RxBool isSubcategory = true.obs;
  Rx<AddingDataType> addingDataTypeGrpVal = AddingDataType.categories.obs;
  RxBool dataLinkGroupValue = false.obs;
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryUrlController = TextEditingController();
  final TextEditingController blogUrlController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  fetchData() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("all-categories").get();
      for (var doc in snapshot.docs) {
        categories.add({"docId": doc.id, "name": doc["name"]});
      }
      dropdownVal.value = categories.first["name"]!;
      docId.value = categories.first["docId"]!;
      isLoading.value = false;
    } catch (e) {
      AppStyle().failedSnakBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    categoryUrlController.dispose();
    super.dispose();
  }

//items  add dialog
  dialog(context) async {
    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                children: [
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Name: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: dropdownVal.value.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ])),
                  //added data type
                  Obx(
                    () => isSubcategory.value == true
                        ? ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: const Text("Categories"),
                                leading: Radio(
                                  value: AddingDataType.categories,
                                  groupValue: addingDataTypeGrpVal.value,
                                  onChanged: (value) {
                                    addingDataTypeGrpVal.value =
                                        AddingDataType.categories;
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text("Blog"),
                                leading: Radio(
                                  value: AddingDataType.blog,
                                  groupValue: addingDataTypeGrpVal.value,
                                  onChanged: (value) {
                                    addingDataTypeGrpVal.value =
                                        AddingDataType.blog;
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text("Video"),
                                leading: Radio(
                                  value: AddingDataType.video,
                                  groupValue: addingDataTypeGrpVal.value,
                                  onChanged: (value) {
                                    addingDataTypeGrpVal.value =
                                        AddingDataType.video;
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ListTile(
                                title: const Text("Data"),
                                leading: Radio(
                                  value: AddingDataType.data,
                                  groupValue: addingDataTypeGrpVal.value,
                                  onChanged: (value) {
                                    addingDataTypeGrpVal.value =
                                        AddingDataType.data;
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),

                  Obx(
                    () => addingDataTypeGrpVal.value ==
                            AddingDataType.categories
                        ? Column(
                            children: [
                              customFormField(categoryNameController, context,
                                  "Category Name", (val) {}),
                              customFormField(categoryUrlController, context,
                                  "URL", (val) {}),
                            ],
                          )
                        : addingDataTypeGrpVal.value == AddingDataType.blog
                            ? Column(
                                children: [
                                  customFormField(categoryNameController,
                                      context, "Category Name", (val) {}),
                                  customFormField(blogUrlController, context,
                                      "BLOG URL", (val) {}),
                                ],
                              )
                            : addingDataTypeGrpVal.value == AddingDataType.video
                                ? Column(
                                    children: [
                                      customFormField(categoryNameController,
                                          context, "Category Name", (val) {}),
                                      customFormField(videoUrlController,
                                          context, "VIDEO URL", (val) {}),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Data Link"),
                                          Flexible(
                                            flex: 1,
                                            child: ListTile(
                                              title: const Text("True"),
                                              leading: Radio(
                                                groupValue:
                                                    dataLinkGroupValue.value,
                                                value: true,
                                                onChanged: (value) {
                                                  dataLinkGroupValue.value =
                                                      true;
                                                },
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: ListTile(
                                              title: const Text("False"),
                                              leading: Radio(
                                                groupValue:
                                                    dataLinkGroupValue.value,
                                                value: false,
                                                onChanged: (value) {
                                                  dataLinkGroupValue.value =
                                                      false;
                                                },
                                              ),
                                            ),
                                          ),
                                          Flexible(flex: 3, child: Container())
                                        ],
                                      ),
                                      customFormField(categoryNameController,
                                          context, "Data title", (val) {}),
                                      customFormField(videoUrlController,
                                          context, "Data value", (val) {}),
                                    ],
                                  ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  //dialog written item add or cancel section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      customButton("Add", () async {
                        if (addingDataTypeGrpVal.value ==
                            AddingDataType.categories) {
                          if (categoryNameController.text.isNotEmpty) {
                            Map<String, dynamic> data = {
                              "all-data": [],
                              "category-name": categoryNameController.text,
                              "url": ""
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection("all-categories")
                                  .doc(docId.value)
                                  .update({
                                "doc-list": FieldValue.arrayUnion([data])
                              }).whenComplete(() => Get.back());
                            } catch (e) {
                              AppStyle().failedSnakBar(e.toString());
                            }
                          } else {
                            AppStyle().failedSnakBar("Enter category name");
                          }
                        }
                        //if AddingDataType is blog
                        else if (addingDataTypeGrpVal.value ==
                            AddingDataType.blog) {
                          if (categoryNameController.text.isNotEmpty &&
                              blogUrlController.text.isNotEmpty) {
                            Map<String, dynamic> data = {
                              "category-name": categoryNameController.text,
                              "blog-url": blogUrlController.text
                            };
                            try {
                              await FirebaseFirestore.instance
                                  .collection("all-categories")
                                  .doc(docId.value)
                                  .update({
                                "doc-list": FieldValue.arrayUnion([data])
                              }).whenComplete(() => Get.back());
                            } catch (e) {
                              AppStyle().failedSnakBar(e.toString());
                            }
                          } else {
                            AppStyle().failedSnakBar(
                                "Enter Category Name and Blog Url");
                          }
                        }
                        //AddinngDataType is Video
                        else {
                          if (categoryNameController.text.isNotEmpty &&
                              videoUrlController.text.isNotEmpty) {
                            Map<String, dynamic> data = {
                              "category-name": categoryNameController.text,
                              "video-url": videoUrlController.text
                            };
                            try {
                              await FirebaseFirestore.instance
                                  .collection("all-categories")
                                  .doc(docId.value)
                                  .update({
                                "doc-list": FieldValue.arrayUnion([data])
                              }).whenComplete(() => Get.back());
                            } catch (e) {
                              AppStyle().failedSnakBar(e.toString());
                            }
                          } else {
                            AppStyle().failedSnakBar(
                                "Enter Category Name and Video Url");
                          }
                        }
                      }),
                      customButton("Cancel", () {
                        Get.back();
                      }),
                    ],
                  )
                ],
              ),
            ));
  }

//delete blog or video  item
  void deleteItem(String collectionName, String docId, String fieldName,
      dynamic removeData) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .update({
        fieldName: FieldValue.arrayRemove([removeData])
      }).whenComplete(() => AppStyle().successSnakBar("successfully removed"));
    } catch (e) {
      AppStyle().failedSnakBar(e.toString());
    }
  }

  //delete a category item
  void deleteCategory(String collectionName, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .delete()
          .whenComplete(
              () => AppStyle().successSnakBar("Successfully deleted"));
    } catch (e) {
      AppStyle().failedSnakBar(e.toString());
    }
  }
}
