import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/theme/colors/colors.dart';

class MyUploadPage extends StatefulWidget {
  final PageController pageController;
  const MyUploadPage({super.key, required this.pageController});

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  bool isLoading = false;
  TextEditingController captionController = TextEditingController();
  File? _image;
  final ImagePicker picker = ImagePicker();

  void uploadNewPost() {
    String caption = captionController.text.trim();
    if (caption.isEmpty || _image == null) {
      return;
    }

    _apiPostImage();
  }

  void _apiPostImage() async {
    setState(() {
      isLoading = true;
    });

    final val = await FileService.uploadPostImage(_image!);
    respPost(val);
  }

  void respPost(String imgUrl) {
    String caption = captionController.text;
    Post post = Post(caption, imgUrl);
    apiStoreFeed(post);
  }

  void apiStoreFeed(Post post) async {
    Post posted = await DataService.storePost(post);

    DataService.storeFeed(posted).then((val) {
      _moveToFeed();
    });
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
    });
    captionController.text = "";
    _image = null;
    widget.pageController.animateToPage(
      0,
      duration: Duration(microseconds: 200),
      curve: Curves.easeIn,
    );
  }

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
              ListTile(
                leading: Icon(Icons.image, color: Color(0xFFF56040)),
                title: Text("Pick Photo"),
                onTap: () {
                  _pickFromGallery();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera, color: Color(0xFFFCAF45)),
                title: Text("Take Photo"),
                onTap: () {
                  _pickFromCamera();
                  Navigator.pop(context);
                },
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
              uploadNewPost();
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
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
