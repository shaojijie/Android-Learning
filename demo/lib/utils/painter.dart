import 'dart:ui';

import 'package:flutter/cupertino.dart';

class PainterUtil {
  /* 画一个点 */
  static void drawPoint(Offset point, Canvas canvas, Paint paint) {
    var points = [point];
    canvas.drawPoints(PointMode.points, points, paint);
  }

  /* 画多个点 */
  static void drawPoints(List<Offset> points, Canvas canvas, Paint paint) {
    canvas.drawPoints(PointMode.points, points, paint);
  }

  /* 画一条直线 */
  static void drawLine(List<Offset> points, Canvas canvas, Paint paint) {
    canvas.drawPoints(PointMode.lines, points, paint);
  }

  /* 多边形 */
  static void drawPolygon(List<Offset> points, Canvas canvas, Paint paint) {
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  /* 多边形 */
  static void drawPath(List<Offset> points, Canvas canvas, Paint paint) {
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length; i++) {
      path.lineTo(points.elementAt(i).dx, points.elementAt(i).dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }
}
