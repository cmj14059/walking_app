import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walking_app/model/page_routing/page_routing_state.dart';
import 'package:walking_app/view_model/home_page/health/health_notifier.dart';

final pageRoutingProvider = StateNotifierProvider((ref) {
  return PageRoutingNotifier();
});

class PageRoutingNotifier extends StateNotifier<PageRoutingState>{
  PageRoutingNotifier(): super(PageRoutingState());

  int getIndex() {
    return state.selectIndex;
  }

  void onTapItem(int index) {
    state = PageRoutingState(selectIndex: index);
  }

  void goMyPage() {
    onTapItem(2);
  }

  void goShopPage() {
    onTapItem(1);
  }

}