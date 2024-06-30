import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:link_lagbe_update/widgets/custom_button.dart';
import 'package:link_lagbe_update/widgets/custom_textfield.dart';

class ViralNews extends StatefulWidget {
  const ViralNews({super.key});

  @override
  State<ViralNews> createState() => _ViralNewsState();
}

class _ViralNewsState extends State<ViralNews> {
  final titleController = TextEditingController();
  final urlController = TextEditingController();
  final thumbnailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final successSnackBar = const SnackBar(
    content: Text('Data add successfully'),
  );
  final errorSnackBar = const SnackBar(
    content: Text('Something is wrong'),
  );

  //for blog images

  PlatformFile? pickedFileForBlogImages;

  Future selectFileForBlogImages(controller) async {
    try {
      // setState(() {
      //   loading = true;
      // });
      // DateTime now = DateTime.now();
      final result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        var time = DateTime.now().millisecondsSinceEpoch.toString();
        final ref =
            FirebaseStorage.instance.ref('viral-news').child('$time.png');
        //.child(now.toString());
        final pickedFileForBlogImages = result.files.first.bytes;
        UploadTask uploadTask = ref.putData(pickedFileForBlogImages!);

        final snapshot = await uploadTask.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        setState(() {
          controller.text = urlDownload;
          // loading = false;
        });
      }
    } catch (e) {
      // print(e.toString());
      //const SnackBar(content: Text('Something is wrong'));
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: customFormField(
                        thumbnailController, context, "Enter image url",
                        (value) {
                      if (value == null || value.isEmpty) {
                        return "this field can't be empty";
                      }

                      return null;
                    }),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      child: IconButton(
                        onPressed: () {
                          selectFileForBlogImages(thumbnailController);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              customFormField(titleController, context, "Enter news title",
                  (value) {
                if (value == null || value.isEmpty) {
                  return "this field can't be empty";
                }

                return null;
              }),
              customFormField(urlController, context, "Enter news url",
                  (value) {
                if (value == null || value.isEmpty) {
                  return "this field can't be empty";
                }

                return null;
              }),
              const SizedBox(
                height: 15,
              ),
              customButton("Add Viral News", () {
                if (_formKey.currentState!.validate()) {
                  try {
                    FirebaseFirestore.instance.collection('viral-news').add({
                      "title": titleController.text.toString(),
                      "news-url": urlController.text.toString(),
                      "thumbnail-url": thumbnailController.text.toString()
                    }).whenComplete(() {
                      titleController.clear();
                      urlController.clear();
                      thumbnailController.clear();
                      //  const SnackBar(content: Text('Data add successfully'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successSnackBar);
                    });
                  } catch (e) {
                    // const SnackBar(content: Text('Something is wrong'));
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
