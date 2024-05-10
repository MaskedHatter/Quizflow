import 'package:flutter/material.dart';

class PageModel extends ChangeNotifier {
  int _index = 0;

  int get pageIndex => _index;

  void changePageIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}
