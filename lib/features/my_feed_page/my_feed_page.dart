import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/utils.dart';

class MyFeedPage extends StatefulWidget {
  final PageController pageController;
  const MyFeedPage({super.key, required this.pageController});

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    apiLoadPosts();
  }

  void apiLoadPosts() async {
    setState(() {
      isLoading = true;
    });
    final val = await DataService.loadFeeds();
    resLoadFeed(val);
  }

  void resLoadFeed(List<Post> list) {
    setState(() {
      items = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        apiLoadPosts();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Instagram",
            style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
          ),

          actions: [
            IconButton(
              onPressed: () {
                widget.pageController.jumpToPage(2);
              },
              icon: Icon(Icons.camera_alt),
            ),
          ],
        ),
        body: isLoading
            ? ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            : items.isEmpty
            ? ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: Text("No posts yet")),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemOfPost(post: items[items.length - index - 1]);
                },
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ItemOfPost extends StatefulWidget {
  final Post post;
  const ItemOfPost({super.key, required this.post});

  @override
  State<ItemOfPost> createState() => _ItemOfPostState();
}

class _ItemOfPostState extends State<ItemOfPost> {
  late Post post;
  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () async {
                    DataService.likePost(post, !post.liked);
                    setState(() {});
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
