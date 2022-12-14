import 'package:flutter_hacker_news_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/stories_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex;

  final box = GetStorage();
  @override
  void initState() {
    super.initState();

    currentIndex = 0;
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget build(context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: topAppBar(),
        backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
        bottomNavigationBar: bottomAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (currentIndex == 0) {
      return TabBarView(
        children: [
          StoriesTab(listType: 'best'),
          StoriesTab(listType: 'top'),
          StoriesTab(listType: 'newest'),
        ],
      );
    } else if (currentIndex == 1) {
      return StoriesTab(listType: 'question');
    } else {
      return StoriesTab(listType: 'job');
    }
  }

  Widget bottomAppBar() {
    return BubbleBottomBar(
      opacity: 0.2,
      backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
      borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      currentIndex: currentIndex,
      hasInk: true,
      inkColor: Colors.white,
      hasNotch: true,
      onTap: changePage,
      items: <BubbleBottomBarItem>[
        bottomBarItem(
          'Home',
          Icon(Icons.home, color: Color.fromRGBO(255, 255, 255, 0.9),),
          Icon(Icons.home, color: Color(0xFF626EE3),)
        ),
        bottomBarItem(
          'Questions',
          Icon(MaterialCommunityIcons.comment_text_multiple, color: Color.fromRGBO(255, 255, 255, 0.9),), 
          Icon(MaterialCommunityIcons.comment_text_multiple, color: Color(0xFF626EE3),)
        ),
        bottomBarItem(
          'Jobs',
          Icon(Icons.work, color: Color.fromRGBO(255, 255, 255, 0.9),), 
          Icon(Icons.work, color: Color(0xFF626EE3),)
        ),
      ],
    );
  }

  BubbleBottomBarItem bottomBarItem(String text, Icon icon, Icon activeIcon) {
    return BubbleBottomBarItem(
      backgroundColor: Color(0xFF626EE3),
      icon: icon,
      activeIcon: activeIcon,
      title: Text(text, style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.w500, fontSize: 14.0)),
    );
  }

  Widget topAppBar() {
    return AppBar(
      title: Text(
        (currentIndex == 0)
        ? 'Hacker News'
        : (currentIndex == 1)
        ? 'Questions'
        : 'Jobs',
        style: TextStyle(
          fontFamily: 'Ubuntu', 
          fontWeight: FontWeight.w600,
          fontSize: 23.0
        ),
      ),
      actions:  [
         InkWell(
           onTap: (){
             box.remove("key");
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const LoginScreen()),
             );
           },
             child: const Padding(
               padding: EdgeInsets.all(8.0),
               child: Icon(Icons.logout,size: 30,),
             ))
      ],
      leading: Padding(
        padding: EdgeInsets.only(
          top: 15.0,
          bottom: 9.0
        ),
        child: Image.asset('assets/apple-touch-icon.png'),
      ),
      elevation: 7.0,
      backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
      bottom: (currentIndex == 0) ? TabBar(
        unselectedLabelColor: Colors.white,
        indicatorColor: Color(0xFF6774e4),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          fontFamily: 'Ubuntu'
        ),
        labelColor: Color(0xFF6774e4),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                Icon(FontAwesome5Solid.rocket),
                Text('  Best', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),),
              ],),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                Icon(Icons.leaderboard_rounded),
                Text('  Top', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
              ],),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                Icon(FontAwesome5Solid.certificate),
                Text('  New',  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
              ],),
          ),
        ],
      ) : null,
    );
  }
}