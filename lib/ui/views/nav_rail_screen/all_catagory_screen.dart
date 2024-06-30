import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:link_lagbe_update/controller/allcategory_screen_controller.dart';
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
                                } else {
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
                                }
                              }),
                        )
                      ],
                    ),
            ));
  }
}
