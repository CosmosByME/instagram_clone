import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/services/utils.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  File? _image;
  // ignore: non_constant_identifier_names
  String fullname = "", email = "", img_url = "";
  // ignore: non_constant_identifier_names
  int count_posts = 0, count_followers = 0, count_following = 0;
  final ImagePicker picker = ImagePicker();

  Future<void> _apiLoadMember() async {
    setState(() {
      isLoading = true;
    });
    final val = await DataService.loadUser();
    _showMemberInfo(val);
  }

  void _showMemberInfo(Member member) {
    setState(() {
      isLoading = false;
      fullname = member.fullname;
      email = member.email;
      img_url = member.img_url;
      count_following = member.following_count;
      count_followers = member.followers_count;
    });
  }

  Future<void> _apiUpdateUser(String imageUrl) async {
    setState(() {
      isLoading = true;
    });

    Member member = await DataService.loadUser();

    setState(() {
      member.img_url = imageUrl;
    });
    await DataService.updateUser(member);
    await _apiLoadMember();
  }

  Future<void> _apiChangePhoto() async {
    if (_image == null) return;
    setState(() => isLoading = true);

    try {
      final downloadUrl = await FileService.uploadUserImage(_image!);
      await _apiUpdateUser(downloadUrl);
    } catch (e) {
      print("Upload failed: $e");
      setState(() => isLoading = false);
    }
  }

  _apiLoadPosts() {
    DataService.loadPosts().then((value) => {_resLoadPosts(value)});
  }

  void _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = posts.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadMember();
    _apiLoadPosts();
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
      await _apiChangePhoto();
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
      await _apiChangePhoto();
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool correct = await Utils.dialogCommon(
                context,
                "Log Out",
                "Are you sure, you want to log out?",
                false,
              );

              if (correct) {
                AuthService.signOut(context);
              }
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          _apiLoadMember();
          _apiLoadPosts();
        },
        child: Container(
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
                        child: img_url.isEmpty
                            ? Image.asset(
                                "assets/images/ic_person.png",
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )
                            //Here I changed image.network to image.file
                            : Image.network(
                                img_url,
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
                        children: [
                          Icon(Icons.add_circle, color: Colors.purple),
                        ],
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
                    return _itemOfPost(context, items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _itemOfPost(BuildContext context, Post post) {
  return GestureDetector(
    onLongPress: () async {
      bool complete = await Utils.dialogCommon(
        context,
        "Remove",
        "Do you want to remove a post?",
        false,
      );

      if (complete) {
        DataService.removePost(post);
      }
    },
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
