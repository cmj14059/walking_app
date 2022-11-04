import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walking_app/const/color/color.dart';
import 'package:walking_app/model/page_routing/page_routing_state.dart';
import 'package:walking_app/view_model/page_routing/page_routing_notifier.dart';

import '../../view_model/home_page/health/health_notifier.dart';
import '../home_page/home_page.dart';
import '../my_page/my_page.dart';
import '../shop_page/shop_page.dart';

class PageRouting extends ConsumerWidget{
  PageRouting({super.key});

  final _pages = <Widget>[
    HomePage(),
    ShopPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageRoutingState = ref.watch(pageRoutingProvider);
    final pageRoutingStateNotifier = ref.watch(pageRoutingProvider.notifier);

    final healthState = ref.watch(healthNotifierProvider);
    final healthStateNotifier = ref.watch(healthNotifierProvider.notifier);

    int selectIndex = pageRoutingStateNotifier.getIndex();
    return Scaffold(
      body: IndexedStack(
        index: selectIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MyPage',
          ),
        ],
        selectedIconTheme: const IconThemeData(
          size: 40,
          color: BOTTOM_BAR_ITEM_COLOR,
          shadows: [
            Shadow(
              color: Colors.blueGrey,
              offset: Offset(3,2),
              blurRadius: 10,
            ),
          ],
        ),
        unselectedIconTheme: const IconThemeData(
          color: WHITE,
          shadows: [
            Shadow(
              color: Colors.blueGrey,
              offset: Offset(2,1),
              blurRadius: 10,
            )
          ],
        ),
        backgroundColor: Colors.blue,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectIndex,
        onTap: pageRoutingStateNotifier.onTapItem,
      ),
    );
  }
}