import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/utils.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({super.key});

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage>
    with AutomaticKeepAliveClientMixin {
  List<Post> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiLoadLiked();
  }

  void apiLoadLiked() async {
    setState(() {
      isLoading = true;
    });

    final val = await DataService.loadLikes();
    _respLikedPosts(val);
  }

  void _respLikedPosts(List<Post> posts) {
    setState(() {
      isLoading = false;
      items = posts;
    });
  }

  void unlikingPost(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });

    DataService.likePost(post, false).then((value) {
      apiLoadLiked();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        apiLoadLiked();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Likes",
            style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
          ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _itemOfPost(items[index]);
          },
        ),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Column(
      children: [
        Divider(color: Colors.grey.shade100),
        //#user info
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: post.img_user.isEmpty
                        ? Image(
                            image: AssetImage("assets/images/ic_person.png"),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            post.img_user,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.fullname,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text(
                        post.date,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              post.mine
                  ? IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () async {
                        bool complete = await Utils.dialogCommon(
                          context,
                          "Remove",
                          "Do you want to remove a post?",
                          false,
                        );

                        if (complete) {
                          DataService.removeFeed(post);
                        }
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        //#post image
        SizedBox(height: 8),
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          imageUrl: post.img_post,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),

        //#like share
        Row(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    unlikingPost(post);
                  },
                  icon: post.liked
                      ? Icon(EvaIcons.heart, color: Colors.red)
                      : Icon(EvaIcons.heartOutline),
                ),
                IconButton(onPressed: () {}, icon: Icon(EvaIcons.shareOutline)),
              ],
            ),
          ],
        ),

        //#caption
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(
              text: post.caption,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
