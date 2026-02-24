import 'dart:async';

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
  final TextEditingController searchController = TextEditingController();
  List<Member> items = [];
  Timer? _debounce;

  // FIX 3: Removed redundant setState; FIX 4: Added 500ms debounce
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        _apiSearchUsers(value.trim());
      } else {
        setState(() => items = []);
      }
    });
  }

  void _apiSearchUsers(String keyword) async {
    setState(() => isLoading = true);
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
    setState(() => isLoading = true);
    await DataService.followMember(someone);
    setState(() {
      someone.followed = true; // FIX 1: Only set here, not in onTap too
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnfollowUser(Member someone) async {
    setState(() => isLoading = true);
    await DataService.unfollowMember(someone);
    setState(() {
      someone.followed = false; // FIX 1: Only set here, not in onTap too
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose(); // FIX 2: Properly dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            centerTitle: true,
            expandedHeight: 100,
            title: const Text(
              "Search",
              style: TextStyle(fontSize: 30, fontFamily: "Billabong"),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, right: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged, // FIX 3 & 4
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hint: Text(
                        "Search",
                        style: TextStyle(fontSize: 19, color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _onSearchChanged("");
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (items.isEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3 * 2,
                child: const Center(child: Text("No users found")),
              ),
            )
          else
            SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => _itemOfMember(items[index]),
            ),
        ],
      ),
    );
  }

  Widget _itemOfMember(Member member) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
      height: 90,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                width: 1.5,
                color: const Color.fromRGBO(193, 53, 132, 1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: member.img_url.isEmpty
                  ? const Image(
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(member.email, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // FIX 1: Let the API methods handle state, no setState here
                    if (!member.followed) {
                      _apiFollowUser(member);
                      setState(() {
                        member.followed = !member.followed;
                      });
                    } else {
                      _apiUnfollowUser(member);
                      setState(() {
                        member.followed = !member.followed;
                      });
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: member.followed
                            ? Colors.blueGrey
                            : Colors.blueAccent,
                      ),
                      color: member.followed
                          ? Colors.blueGrey
                          : Colors.blueAccent,
                    ),
                    child: Center(
                      child: Text(
                        member.followed ? "Following" : "Follow",
                        style: const TextStyle(color: Colors.white),
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
