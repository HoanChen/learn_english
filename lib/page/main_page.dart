import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/page/study_page.dart';
import 'package:learn_english/page/word_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final _pagesTitles = ['开始学习', '单词管理'];
  var _currentIndex = 0;
  PageController _pageController;
  final Color _defaultColor = Color(0xFF4d4d4d);
  final Color _activeColor = Color(0xFF1d87ed);

  @override
  void initState() {
    super.initState();
    this._pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pagesTitles[_currentIndex]),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[StudyPage(), WordPage()],
        onPageChanged: (index) {
          log('-----------onPageChanged:$index');
        },
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.play_circle_outline,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.pause_circle_outline,
                color: _activeColor,
              ),
              title: Text(
                '学习',
                style: TextStyle(
                    color: _currentIndex == 0 ? _activeColor : _defaultColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.font_download,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.font_download,
                color: _activeColor,
              ),
              title: Text(
                '单词',
                style: TextStyle(
                    color: _currentIndex == 1 ? _activeColor : _defaultColor),
              )),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
      ),
    );
  }
}
