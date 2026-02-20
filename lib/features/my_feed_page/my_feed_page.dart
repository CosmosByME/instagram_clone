import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';

class MyFeedPage extends StatefulWidget {
  final PageController pageController;
  const MyFeedPage({super.key, required this.pageController});

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage>
    with AutomaticKeepAliveClientMixin {
  List<Post> items = [];
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemOfPost(post: items[index]);
        },
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
                  ? IconButton(icon: Icon(Icons.more_horiz), onPressed: () {})
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
                    if (!post.liked) {
                      setState(() {
                        post.liked = !post.liked;
                      });
                    } else {
                      setState(() {
                        post.liked = !post.liked;
                      });
                    }
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
