import 'package:flutter/material.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/services/data_service.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<Member> items = [];

  void _apiSearchUsers(String keyword) async {
    setState(() {
      isLoading = true;
    });

    final val = await DataService.searchUsers(keyword);
    _respSearchUsers(val);
  }

  void _respSearchUsers(List<Member> members) {
    setState(() {
      isLoading = false;
      items = members;
    });
  }

  void _apiFollowUser(Member someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.followMember(someone);

    setState(() {
      someone.followed = true;
      isLoading = false;
    });

    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnfollowUser(Member someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.unfollowMember(someone);

    setState(() {
      someone.followed = false;
      isLoading = false;
    });

    DataService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            centerTitle: true,
            expandedHeight: 100,
            title: Text(
              "Search",
              style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Container(
                  height: 45,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      _apiSearchUsers(value);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _itemOfMember(items[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _itemOfMember(Member member) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
      height: 90,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                width: 1.5,
                color: Color.fromRGBO(193, 53, 132, 1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: member.img_url.isEmpty
                  ? Image(
                      image: AssetImage("assets/images/ic_person.png"),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      member.img_url,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullname,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  member.email,
                  style: TextStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    !member.followed
                        ? _apiFollowUser(member)
                        : _apiUnfollowUser(member);
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: !member.followed
                            ? Colors.blueAccent
                            : Colors.blueGrey,
                      ),
                      color: !member.followed
                          ? Colors.blueAccent
                          : Colors.blueGrey,
                    ),
                    child: Center(
                      child: member.followed
                          ? Text("Following")
                          : Text(
                              "Follow",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
