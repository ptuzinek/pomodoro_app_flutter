import 'package:flutter/foundation.dart';

class ViewHolder extends ChangeNotifier {
  double value;

  ViewHolder({this.value});

  void setValue(newValue) {
    this.value = newValue;
    notifyListeners();
  }
}
