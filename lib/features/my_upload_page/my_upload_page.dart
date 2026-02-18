import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/theme/colors/colors.dart';

class MyUploadPage extends StatefulWidget {
  final PageController pageController;
  const MyUploadPage({super.key, required this.pageController});

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  TextEditingController captionController = TextEditingController();
  File? _image;
  final ImagePicker picker = ImagePicker();

  void _pickFromGallery() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _pickFromCamera() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Card(
                color: AppColors.primaryFirst,
                child: ListTile(
                  leading: Icon(Icons.image, color: Color(0xFFF56040)),
                  title: Text("Pick Photo"),
                  onTap: () {
                    _pickFromGallery();
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                color: AppColors.primarySecond,
                child: ListTile(
                  leading: Icon(Icons.camera, color: Color(0xFFFCAF45)),
                  title: Text("Take Photo"),
                  onTap: () {
                    _pickFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10, width: double.infinity),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload",
          style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController.jumpToPage(0);
            },
            icon: Icon(
              Icons.drive_folder_upload,
              color: AppColors.primarySecond,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showPicker(context);
              },
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                color: Colors.grey.withValues(alpha: 0.4),
                child: _image == null
                    ? Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.grey,
                        ),
                      )
                    : Image.file(
                        _image!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: TextField(
                controller: captionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  focusColor: AppColors.primarySecond,
                  hintText: "Caption",
                  hintStyle: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
