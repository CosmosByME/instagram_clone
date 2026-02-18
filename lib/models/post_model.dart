class Post {
  String uid = "";
  String fullname = "UserName";
  // ignore: non_constant_identifier_names
  String img_user = "";

  String id = "";
  // ignore: non_constant_identifier_names
  String img_post = "";
  String caption = "";
  String date = "Feb 19 2026";
  bool liked = false;

  bool mine = false;

  Post(this.caption, this.img_post);

  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        img_user = json['img_user'],
        img_post = json['img_post'],
        id = json['id'],
        caption = json['caption'],
        date = json['date'],
        liked = json['liked'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullname': fullname,
    'img_user': img_user,
    'id': id,
    'img_post': img_post,
    'caption': caption,
    'date': date,
    'liked': liked,
  };
}