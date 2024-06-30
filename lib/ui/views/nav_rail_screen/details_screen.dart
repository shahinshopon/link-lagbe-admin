import 'package:flutter/material.dart';
import 'package:link_lagbe_update/widgets/show_dialog.dart';

class DetailsScreen extends StatefulWidget {
  final bool hasSubcategory;
  var data;
  final String docId;
  DetailsScreen(
      {required this.docId,
      required this.data,
      required this.hasSubcategory,
      super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _dataTitleController = TextEditingController();
  final TextEditingController _dataValueController = TextEditingController();
  String dataLinkGroupValue = "true";

  @override
  void dispose() {
    _dataTitleController.dispose();
    _dataValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.data[index]["data-title"]),
                  subtitle: Text(widget.data[index]["data-value"]),
                  trailing: IconButton(
                      onPressed: () {
                        _dataTitleController.text =
                            widget.data[index]["data-title"];
                        _dataValueController.text =
                            widget.data[index]["data-value"];
                        dataLinkGroupValue =
                            widget.data[index]["data-link"].toString();
                        customDialog(context, _dataTitleController,
                            _dataValueController, dataLinkGroupValue);
                      },
                      icon: const Icon(Icons.edit_document)),
                );
              },
            )
            // dataShowingBox(context, _dataTitleController, _dataValueController,
            //     dataLinkGroupValue)
          ],
        ),
      ),
    );
  }
}
