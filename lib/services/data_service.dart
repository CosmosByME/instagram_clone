import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/services/prefs.dart';

class DataService {
  static Future storeUser(Member user) async {
    user.uid = (await Prefs.loadUserId())!;
    final firestore = FirebaseFirestore.instance;
    return firestore.collection("users").doc(user.uid).set(user.toJson());
  }

  static Future<Member> loadUser() async {
    String uid = (await Prefs.loadUserId())!;
    final firestore = FirebaseFirestore.instance;
    final result = await firestore.collection("users").doc(uid).get();
    return Member.fromJson(result.data()!);
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
}
