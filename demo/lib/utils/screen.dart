import 'dart:ui';

import 'package:flutter/cupertino.dart';

final ScreenUtil screenUtil = ScreenUtil();

class ScreenUtil {
  Size? GetWidgetSize(GlobalKey globalKey) {
    return globalKey.currentContext?.findRenderObject()?.paintBounds?.size;
  }

  Size GetPhysicalSize() {
    return Size(window.physicalSize.width, window.physicalSize.height);
  }
}
