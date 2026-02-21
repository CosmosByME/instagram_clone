import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/prefs.dart';

class DataService {
  static final _firestore = FirebaseFirestore.instance;

  // ignore: non_constant_identifier_names
  static String folder_users = "users";
  // ignore: non_constant_identifier_names
  static String folder_posts = "posts";
  // ignore: non_constant_identifier_names
  static String folder_feeds = "feeds";
  // ignore: non_constant_identifier_names
  static String folder_following = "following";
  // ignore: non_constant_identifier_names
  static String folder_followers = "followers";

  static Future storeUser(Member user) async {
    user.uid = (await Prefs.loadUserId())!;
    final firestore = FirebaseFirestore.instance;
    return firestore.collection("users").doc(user.uid).set(user.toJson());
  }

  static Future<Member> loadUser() async {
    String uid = (await Prefs.loadUserId())!;
    final firestore = FirebaseFirestore.instance;
    final result = await firestore.collection("users").doc(uid).get();
    final user = Member.fromJson(result.data()!);

    var querySnapshot1 = await firestore
        .collection("users")
        .doc(uid)
        .collection("followers")
        .get();
    user.followers_count = querySnapshot1.docs.length;

    var querySnapshot2 = await firestore
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();
    user.following_count = querySnapshot2.docs.length;
    return user;
  }

  static Future updateUser(Member user) async {
    String uid = (await Prefs.loadUserId())!;
    final firestore = FirebaseFirestore.instance;
    return firestore.collection("users").doc(uid).update(user.toJson());
  }

  static Future<List<Member>> searchUsers(String keyword) async {
    List<Member> items = [];
    final firestore = FirebaseFirestore.instance;
    var querySnapshot = await firestore
        .collection("users")
        .orderBy("email")
        .startAt([keyword])
        .get();

    for (var item in querySnapshot.docs) {
      items.add(Member.fromJson(item.data()));
    }

    return items;
  }

  static Future<Post> storePost(Post post) async {
    Member me = await loadUser();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = currentDate();

    String postId = _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;

    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = (await Prefs.loadUserId())!;
    await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = (await Prefs.loadUserId())!;

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }
    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = (await Prefs.loadUserId())!;
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .orderBy("date", descending: false)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }

    return posts;
  }

  static Future likePost(Post post, bool liked) async {
    String uid = (await Prefs.loadUserId())!;
    post.liked = liked;

    await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());

    if (uid == post.uid) {
      await _firestore
          .collection(folder_users)
          .doc(uid)
          .collection(folder_posts)
          .doc(post.id)
          .set(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = (await Prefs.loadUserId())!;
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .where("liked", isEqualTo: true)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }
    return posts;
  }

  static Future<Member> followMember(Member someone) async {
    Member me = await loadUser();

    // I followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .set(me.toJson());

    return someone;
  }

  static Future<Member> unfollowMember(Member someone) async {
    Member me = await loadUser();

    // I un followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .delete();

    // I am not in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .delete();

    return someone;
  }

  static Future storePostsToMyFeed(Member someone) async {
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();
    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    }

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = (await Prefs.loadUserId())!;

    return await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .delete();
  }

  static Future removePost(Post post) async {
    String uid = (await Prefs.loadUserId())!;
    await removeFeed(post);
    return await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .doc(post.id)
        .delete();
  }

  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}";
    return convertedDateTime;
  }
}
