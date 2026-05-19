import 'package:flutter/foundation.dart';

class AppSettingsProvider extends ChangeNotifier {
  double _textScale = 1.0;

  double get textScale => _textScale;

  void setTextScale(double value) {
    if ((_textScale - value).abs() < 0.001) {
      return;
    }

    _textScale = value;
    notifyListeners();
  }
}
