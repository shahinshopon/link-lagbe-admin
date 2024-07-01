import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:link_lagbe_update/controller/allcategory_screen_controller.dart';
import 'package:link_lagbe_update/ui/style/style.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/details_screen.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<AllCategoryScreenController>(
        init: AllCategoryScreenController(),
        builder: (controller) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  controller.dialog(context);
                },
                child: const Icon(Icons.add),
              ),
              body: controller.isLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        DropdownButton(
                            value: controller.dropdownVal.value,
                            items: controller.categories
                                .map((item) => DropdownMenuItem(
                                      value: item["name"],
                                      child: Text(item["name"]!),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              controller.dropdownVal.value = val.toString();
                              for (var element in controller.categories) {
                                if (element["name"] == val.toString()) {
                                  controller.docId.value =
                                      element["docId"].toString();
                                }
                              }
                            }),
                        Expanded(
                          child: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("all-categories")
                                  .doc(controller.docId.value)
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
                                } else if (snapshot.hasData) {
                                  controller.isSubcategory.value =
                                      snapshot.data!["sub-category"];
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        if (snapshot.data!["sub-category"] ==
                                            true) ...[
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data!["doc-list"].length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    snapshot.data!["doc-list"]
                                                                [index]
                                                            .containsKey(
                                                                "all-data")
                                                        ? Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DetailsScreen(
                                                                          data: snapshot.data!["doc-list"][index]
                                                                              [
                                                                              "all-data"],
                                                                          hasSubcategory:
                                                                              true,
                                                                          docId: controller
                                                                              .docId
                                                                              .value,
                                                                        )))
                                                        : null;
                                                  },
                                                  child: Card(
                                                    elevation: .5,
                                                    child: ListTile(
                                                      title: Text(
                                                        snapshot.data![
                                                                    "doc-list"]
                                                                [index]
                                                            ["category-name"],
                                                      ),
                                                      //if exits all-data field
                                                      subtitle: snapshot
                                                              .data!["doc-list"]
                                                                  [index]
                                                              .containsKey(
                                                                  "all-data")
                                                          ? const Text("")
                                                          : snapshot
                                                                  .data!["doc-list"]
                                                                      [index]
                                                                  .containsKey(
                                                                      "blog-url")
                                                              ? Text(
                                                                  snapshot.data!["doc-list"][index]["blog-url"]
                                                                      .toString())
                                                              : Text(snapshot
                                                                  .data!["doc-list"]
                                                                      [index]
                                                                      ["video-url"]
                                                                  .toString()),
                                                      trailing: !snapshot
                                                              .data!["doc-list"]
                                                                  [index]
                                                              .containsKey(
                                                                  "all-data")
                                                          ? IconButton(
                                                              onPressed: () {
                                                                Map<String,
                                                                        dynamic>
                                                                    removeBlogData =
                                                                    {
                                                                  "blog-url": snapshot
                                                                              .data!["doc-list"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "blog-url"],
                                                                  "category-name":
                                                                      snapshot.data!["doc-list"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "category-name"]
                                                                };
                                                                Map<String,
                                                                        dynamic>
                                                                    removeVideoData =
                                                                    {
                                                                  "video-url": snapshot
                                                                              .data!["doc-list"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "video-url"],
                                                                  "category-name":
                                                                      snapshot.data!["doc-list"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "category-name"]
                                                                };

                                                                AppStyle().showAlertDialog(
                                                                    context,
                                                                    continueFun:
                                                                        () {
                                                                  snapshot.data![
                                                                              "doc-list"]
                                                                              [
                                                                              index]
                                                                          .containsKey(
                                                                              "blog-url")
                                                                      ? controller.deleteItem(
                                                                          "all-categories",
                                                                          controller
                                                                              .docId
                                                                              .value,
                                                                          "doc-list",
                                                                          removeBlogData)
                                                                      : controller.deleteItem(
                                                                          "all-categories",
                                                                          controller
                                                                              .docId
                                                                              .value,
                                                                          "doc-list",
                                                                          removeVideoData);
                                                                },
                                                                    title:
                                                                        "Alert",
                                                                    message:
                                                                        "Do you want to delete the item?");
                                                              },
                                                              icon: const Icon(Icons
                                                                  .delete_outline))
                                                          : snapshot
                                                                      .data![
                                                                          "doc-list"]
                                                                          [
                                                                          index]
                                                                          [
                                                                          "all-data"]
                                                                      .length ==
                                                                  0
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Map<String,
                                                                            dynamic>
                                                                        removeData =
                                                                        {
                                                                      "all-data":
                                                                          [],
                                                                      "category-name":
                                                                          snapshot.data!["doc-list"][index]
                                                                              [
                                                                              "category-name"],
                                                                      "url": snapshot.data!["doc-list"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "url"],
                                                                    };
                                                                    AppStyle().showAlertDialog(
                                                                        context,
                                                                        continueFun:
                                                                            () {
                                                                      controller.deleteItem(
                                                                          "all-categories",
                                                                          controller
                                                                              .docId
                                                                              .value,
                                                                          "doc-list",
                                                                          removeData);
                                                                    },
                                                                        title:
                                                                            "Delete",
                                                                        message:
                                                                            "Do you want to delte the folder");
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .folder_delete_outlined),
                                                                )
                                                              : const SizedBox(),
                                                    ),
                                                  ),
                                                );
                                              })
                                        ] else ...[
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data!["all-data"].length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  elevation: .5,
                                                  child: ListTile(
                                                    title: Text(
                                                      snapshot.data!["all-data"]
                                                          [index]["data-title"],
                                                    ),
                                                    subtitle: Text(snapshot
                                                            .data!["all-data"]
                                                        [index]["data-value"]),
                                                  ),
                                                );
                                              })
                                        ]
                                      ],
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
            ));
  }
}
