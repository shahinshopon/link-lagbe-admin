import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:link_lagbe_update/const/custom_data_type.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/details_screen.dart';
import 'package:link_lagbe_update/widgets/custom_button.dart';
import 'package:link_lagbe_update/widgets/custom_textfield.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  // List<QueryDocumentSnapshot> snapshotData = [];

  DocumentSnapshot? snapshotData;
  RxBool isLoading = false.obs;
  List<Map<String, String>> categories = [];
  RxString dropdownVal = "".obs;
  RxString docId = "".obs;
  final Rx<AddingDataType> addingDataTypeGrpVal = AddingDataType.categories.obs;
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryUrlController = TextEditingController();
  @override
  void initState() {
    fetchData();
    super.initState();
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
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  print(snapshotData[0]["name"]);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
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
                          () => ListView(
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
                          ),
                        ),
                        addingDataTypeGrpVal.value == AddingDataType.categories
                            ? Column(
                                children: [
                                  customFormField(_categoryNameController,
                                      context, "Category Name", (val) {}),
                                  customFormField(_categoryUrlController,
                                      context, "URL", (val) {}),
                                ],
                              )
                            : Text(""),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        //dialog written item add or cancel section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            customButton("Add", () async {
                              Map<String, dynamic> data = {
                                "all-data": [],
                                "category-name": _categoryNameController.text,
                                "url": ""
                              };

                              try {
                                await FirebaseFirestore.instance
                                    .collection("all-categories")
                                    .doc(docId.value)
                                    .update({
                                  "doc-list": FieldValue.arrayUnion([data])
                                });
                              } catch (e) {
                                print(e.toString());
                              }
                            }),
                            customButton("Cancel", () {
                              Navigator.pop(context);
                            }),
                          ],
                        )
                      ],
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() => isLoading.value == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                DropdownButton(
                    value: dropdownVal.value,
                    items: categories
                        .map((item) => DropdownMenuItem(
                              value: item["name"],
                              child: Text(item["name"]!),
                            ))
                        .toList(),
                    onChanged: (val) {
                      dropdownVal.value = val.toString();
                      for (var element in categories) {
                        if (element["name"] == val.toString()) {
                          docId.value = element["docId"].toString();
                        }
                      }
                    }),
                Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("all-categories")
                          .doc(docId.value)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                if (snapshot.data!["sub-category"] == true) ...[
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshot.data!["doc-list"].length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            snapshot.data!["doc-list"][index]
                                                    .containsKey("all-data")
                                                ? Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsScreen(
                                                              data: snapshot
                                                                          .data![
                                                                      "doc-list"]
                                                                  [
                                                                  index]["all-data"],
                                                              hasSubcategory:
                                                                  true,
                                                              docId:
                                                                  docId.value,
                                                            )))
                                                : null;
                                          },
                                          child: Card(
                                            elevation: .5,
                                            child: ListTile(
                                              title: Text(
                                                snapshot.data!["doc-list"]
                                                    [index]["category-name"],
                                              ),
                                              //if exits all-data field
                                              subtitle: snapshot
                                                      .data!["doc-list"][index]
                                                      .containsKey("all-data")
                                                  ? const Text("")
                                                  : snapshot.data!["doc-list"]
                                                              [index]
                                                          .containsKey(
                                                              "blog-url")
                                                      ? Text(snapshot
                                                          .data!["doc-list"]
                                                              [index]
                                                              ["blog-url"]
                                                          .toString())
                                                      : Text(snapshot
                                                          .data!["doc-list"]
                                                              [index]
                                                              ["video-url"]
                                                          .toString()),
                                            ),
                                          ),
                                        );
                                      })
                                ] else ...[
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshot.data!["all-data"].length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: .5,
                                          child: ListTile(
                                            title: Text(
                                              snapshot.data!["all-data"][index]
                                                  ["data-title"],
                                            ),
                                            subtitle: Text(
                                                snapshot.data!["all-data"]
                                                    [index]["data-value"]),
                                          ),
                                        );
                                      })
                                ]
                              ],
                            ),
                          );
                        }
                      }),
                )
              ],
            )),
    );
  }
}
