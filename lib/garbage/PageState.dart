import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Page2.dart';


class PageState extends StatefulWidget {
  const PageState({Key? key}) : super(key: key);

  @override
  State<PageState> createState() => _HomeState();
}

class _HomeState extends State<PageState> {
  var _selectIndex = 0;

  final _pages = <Widget>[
    //HomePage(title: '',),
    Page2(),
    //Page3(),
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
      index: _selectIndex,
      children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedIconTheme: const IconThemeData(
          size: 40,
          color: Colors.blueAccent,
          shadows: [
            Shadow(
              color: Colors.blueGrey,
              offset: Offset(3,2),
              blurRadius: 10,
            ),
          ],
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.blueGrey,
          shadows: [
            Shadow(
              color: Colors.blueGrey,
              offset: Offset(2,1),
              blurRadius: 10,
            )
          ],
        ),
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectIndex,
        onTap: _onTapItem,
      ),
    );
  }
}