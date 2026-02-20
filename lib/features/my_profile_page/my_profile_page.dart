import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/sign_up_page/sign_up_page.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/auth_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  File? _image;
  // ignore: non_constant_identifier_names
  String fullname = "userName", email = "username@gmail.com", img_url = "";
  // ignore: non_constant_identifier_names
  int count_posts = 2, count_followers = 154, count_following = 1545;
  final ImagePicker picker = ImagePicker();

  String image1 =
      "https://gdgouxislhxtvilncrkk.supabase.co/storage/v1/object/sign/images/1.jfif?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9mZGUxNGQ4MS03ZTY1LTQyOTEtYTJmMi1lMjk2ZTNmNGFkMWMiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvMS5qZmlmIiwiaWF0IjoxNzcxNDE5NzE2LCJleHAiOjE3NzIwMjQ1MTZ9.pOzAxQ0MykROV0-n73PEsOeGhnHPMHirNhv4zmZ9pPY";

  String image2 =
      "https://gdgouxislhxtvilncrkk.supabase.co/storage/v1/object/sign/images/2.jfif?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9mZGUxNGQ4MS03ZTY1LTQyOTEtYTJmMi1lMjk2ZTNmNGFkMWMiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvMi5qZmlmIiwiaWF0IjoxNzcxNDE5NzYxLCJleHAiOjE3NzIwMjQ1NjF9.I-edoncv0cw-NQi5B2Kh2DG5vAZbBhL07q3iVourRNU";

  @override
  void initState() {
    super.initState();
    items.add(Post("Very beautiful sunset", image1));
    items.add(Post("Beautiful mountains", image2));
  }

  void _pickFromGallery() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
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
      imageQuality: 100,
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
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut(context);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showPicker(context);
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                        width: 1.5,
                        color: Color.fromRGBO(193, 53, 132, 1),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(45),
                      child: _image == null || _image!.path.isEmpty
                          ? Image.asset(
                              "assets/images/ic_person.png",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          //Here I changed image.network to image.file
                          : Image.file(
                              _image!,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 98,
                    height: 98,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Icon(Icons.add_circle, color: Colors.purple)],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Text(
              fullname.toUpperCase(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3),
            Text(
              email,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            count_posts.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "POSTS",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            count_followers.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "FOLLOWERS",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            count_following.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "FOLLOWING",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            axisCount = 1;
                          });
                        },
                        icon: Icon(Icons.list_alt),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            axisCount = 2;
                          });
                        },
                        icon: Icon(Icons.grid_view),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: axisCount,
                ),
                itemBuilder: (context, index) {
                  return _itemOfPost(items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _itemOfPost(Post post) {
  return GestureDetector(
    onLongPress: () {},
    child: Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 3),
          Text(post.caption, maxLines: 2),
        ],
      ),
    ),
  );
}
