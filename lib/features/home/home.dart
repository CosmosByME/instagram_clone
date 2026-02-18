import 'package:flutter/material.dart';
import 'package:instagram_clone/features/my_feed_page/my_feed_page.dart';
import 'package:instagram_clone/features/my_likes_page/my_likes_page.dart';
import 'package:instagram_clone/features/my_profile_page/my_profile_page.dart';
import 'package:instagram_clone/features/my_search_page/my_search_page.dart';
import 'package:instagram_clone/features/my_upload_page/my_upload_page.dart';
import 'package:instagram_clone/theme/colors/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  int currentPage = 0;
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          MyFeedPage(pageController: controller),
          MySearchPage(),
          MyUploadPage(pageController: controller),
          MyLikesPage(),
          MyProfilePage(),
        ],
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
            controller.jumpToPage(value);
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColors.primaryFirst,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Likes"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
