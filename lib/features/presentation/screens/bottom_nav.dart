import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:video_uploading/features/presentation/screens/home_screen.dart';
import 'package:video_uploading/features/presentation/screens/video_upload_screen.dart';

import 'Notification/notification.dart';
import 'discover/discover.dart';
import 'group/group.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DiscoverPage(),
    VideoUpload(),
    GroupPage(),
    NotificationPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1B1E25),
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          // backgroundColor: const Color(0xff1B1E25),
          selectedItemColor: const Color(0xff54A8E5),
          unselectedItemColor: const Color(0xff636882),
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_earth_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_earth_filled),
                label: 'Discovery'),
            BottomNavigationBarItem(
                icon: Icon(
                  FluentSystemIcons.ic_fluent_add_circle_regular,
                  size: 32,
                ),
                activeIcon: Icon(
                  FluentSystemIcons.ic_fluent_add_circle_filled,
                  size: 32,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon:
                    Icon(FluentSystemIcons.ic_fluent_people_community_regular),
                activeIcon:
                    Icon(FluentSystemIcons.ic_fluent_people_community_filled),
                label: 'Group'),
            BottomNavigationBarItem(
                icon: Icon(
                    FluentSystemIcons.ic_fluent_channel_notifications_regular),
                activeIcon: Icon(
                    FluentSystemIcons.ic_fluent_channel_notifications_filled),
                label: 'Notification'),
          ],
        ));
  }
}
