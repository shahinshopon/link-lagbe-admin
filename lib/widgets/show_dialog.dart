import 'package:flutter/material.dart';
import 'package:link_lagbe_update/widgets/custom_button.dart';
import 'package:link_lagbe_update/widgets/custom_textfield.dart';

customDialog(context, TextEditingController dataTitleController,
    TextEditingController dataValueController, dataLinkGroupValue) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            customFormField(
                dataTitleController, context, "Data title", (val) {}),
            customFormField(
                dataValueController, context, "Data value", (val) {}),
            SizedBox(
              width: 600,
              height: 50,
              child: Row(
                children: [
                  const Text(
                    "Data Link",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 150,
                    child: RadioListTile(
                        title: const Text("True"),
                        value: "true",
                        groupValue: dataLinkGroupValue,
                        onChanged: (val) {
                          dataLinkGroupValue = val;
                          setState(
                            () {},
                          );
                        }),
                  ),
                  SizedBox(
                    width: 150,
                    child: RadioListTile(
                        title: const Text("False"),
                        value: "false",
                        groupValue: dataLinkGroupValue,
                        onChanged: (val) {
                          dataLinkGroupValue = val;
                          setState(
                            () {},
                          );
                        }),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                customButton("cancel", () {
                  Navigator.pop(context);
                }),
                customButton("update", () {
                  // FirebaseFirestore.instance.collection("").doc().update({"data-list":});
                }),
              ],
            )
          ],
        );
      }),
    ),
  );
}
