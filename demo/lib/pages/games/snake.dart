import 'dart:async';
import 'dart:ui';
import 'package:demo/utils/log.dart';
import 'package:demo/utils/painter.dart';
import 'package:demo/utils/random.dart';
import 'package:demo/utils/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum GameStatus {
  GAME_STATUS_STOP,
  GAME_STATUS_CONTINUE,
  GAME_STATUS_WIN,
  GAME_STATUS_FAIL,
}

class _SnakePoint {
  int x;
  int y;

  // List<Offset> points = [];

  _SnakePoint(this.x, this.y);

  factory _SnakePoint.NullPoint() {
    return _SnakePoint(-1, -1);
  }

  void setPoints(List<Offset> points) {
    // this.points.clear();
    // this.points.addAll(points);
  }

  bool equals(_SnakePoint o) {
    if (this.x == o.x && this.y == o.y) {
      return true;
    }
    return false;
  }

  bool isNullPoint() {
    return this.equals(_SnakePoint.NullPoint());
  }

  @override
  String toString() {
    // TODO: implement toString
    return x.toString() + ' ' + y.toString();
  }
}

class _SnakeContext {
  /* 行数 */
  int yCounts;

  /* 列数 */
  int xCounts;

  int pointXSize = 0;

  int pointYSize = 0;

  /* 坐标位置 */
  List<List<_SnakePoint>> map = [];

  /* 贪吃蛇坐标 */
  List<_SnakePoint> snake = [];

  /* 食物可选坐标*/
  List<_SnakePoint> _foods = [];

  _SnakePoint food = _SnakePoint.NullPoint();

  GameStatus _status = GameStatus.GAME_STATUS_STOP;

  _SnakeContext(this.xCounts, this.yCounts);

  void updateMap(int xCounts, int yCounts, int pointXSizw, int pointYSize) {
    this.xCounts = xCounts;
    this.yCounts = yCounts;
    this.pointXSize = pointXSizw;
    this.pointYSize = pointYSize;
    this.map.clear();
    for (int i = 0; i < this.xCounts; i++) {
      List<_SnakePoint> line = [];
      for (int j = 0; j < this.yCounts; j++) {
        line.add(_SnakePoint(i, j));
      }
      this.map.add(line);
    }

    if (this.snake.isEmpty) {
      this.snake.add(_SnakePoint((xCounts / 2).toInt(), (yCounts / 2).toInt()));
      _status = GameStatus.GAME_STATUS_CONTINUE;
    }
    _updateFoods();
  }

  void _updateFoods() {
    this._foods.clear();
    for (int i = 0; i < this.xCounts; i++) {
      for (int j = 0; j < this.yCounts; j++) {
        if (this._isPointOnSnake(this.map.elementAt(i).elementAt(j))) {
          continue;
        }
        this._foods.add(this.map.elementAt(i).elementAt(j));
      }
    }
  }

  void updateSnake(_SnakePoint newHead, bool isEat) {
    List<_SnakePoint> newSnake = [newHead];
    if (!isEat) {
      this.snake.removeLast();
    } else {
      this.food = _SnakePoint.NullPoint();
    }
    newSnake.addAll(this.snake);
    this.snake.clear();
    this.snake.addAll(newSnake);
    _updateFoods();
  }

  _SnakePoint getMapPoint(int x, int y) {
    if (x < 0 || x >= this.xCounts || y < 0 || y >= this.yCounts) {
      logUtil.d("null point");
      return _SnakePoint.NullPoint();
    }
    return this.map.elementAt(x).elementAt(y);
  }

  _SnakePoint getSnakeHead() {
    return this.snake.first;
  }

  bool _isPointOnSnake(_SnakePoint point) {
    for (_SnakePoint p in this.snake) {
      if (p.equals(point)) {
        return true;
      }
    }
    return false;
  }

  int leftFoodCount() {
    this.updateFood();
    return this._foods.length;
  }

  void updateFood() {
    if (!this.food.equals(_SnakePoint.NullPoint())) {
      return;
    }

    _updateFoods();
    int loca = RandomUtil.nextInt(end: this._foods.length);
    this.food = this._foods.elementAt(loca);
  }

  _SnakePoint getFood() {
    return this.food;
  }

  bool isWin() {
    return this._status == GameStatus.GAME_STATUS_WIN;
  }

  bool isOver() {
    return this._status == GameStatus.GAME_STATUS_FAIL;
  }

  void updateStatus(GameStatus status) {
    logUtil.d("update status" + status.toString());
    this._status = status;
  }

  void clear() {
    this.xCounts = 0;
    this.yCounts = 0;
    this._status = GameStatus.GAME_STATUS_CONTINUE;
    this.map.clear();
    this.snake.clear();
    this._foods.clear();
    this.food = _SnakePoint.NullPoint();
  }

  List<Offset> getPointOffset(_SnakePoint point) {
    List<Offset> list = [];

    Offset center = Offset((this.pointXSize / 2) + point.x * this.pointXSize,
        (this.pointYSize / 2) + point.y * this.pointYSize);

    list.add(Offset(
        center.dx - this.pointXSize / 2, center.dy - this.pointYSize / 2));

    list.add(Offset(
        center.dx + this.pointXSize / 2, center.dy - this.pointYSize / 2));

    list.add(Offset(
        center.dx + this.pointXSize / 2, center.dy + this.pointYSize / 2));

    list.add(Offset(
        center.dx - this.pointXSize / 2, center.dy + this.pointYSize / 2));

    list.add(Offset(
        center.dx - this.pointXSize / 2, center.dy - this.pointYSize / 2));

    return list;
  }
}

enum SnakeDirection {
  DIRECTION_UP,
  DIRECTION_DOWN,
  DIRECTION_LEFT,
  DIRECTION_RIGHT,
}

_SnakeContoller g_contoller = _SnakeContoller();

class _SnakeContoller {
  late _SnakeContext _context;
  late Canvas canvas;
  SnakeDirection currentDirection = SnakeDirection.DIRECTION_UP;

  _SnakeContoller() {
    this._context = _SnakeContext(-1, -1);
  }

  void changeDirection(SnakeDirection direction) {
    currentDirection = direction;
  }

  void setMap(int xCounts, int yCounts, int pointXSize, int pointYSize) {
    this._context.updateMap(xCounts, yCounts, pointXSize, pointYSize);
  }

  bool _isGameOver(SnakeDirection direction) {
    _SnakePoint heade = this._context.getSnakeHead();
    if (direction == SnakeDirection.DIRECTION_UP && heade.y == 0) {
      logUtil.d("game over");
      this._context.updateStatus(GameStatus.GAME_STATUS_FAIL);
    }

    if (direction == SnakeDirection.DIRECTION_DOWN &&
        heade.y == this._context.yCounts - 1) {
      logUtil.d("game over");
      this._context.updateStatus(GameStatus.GAME_STATUS_FAIL);
    }

    if (direction == SnakeDirection.DIRECTION_LEFT && heade.x == 0) {
      logUtil.d("game over");
      this._context.updateStatus(GameStatus.GAME_STATUS_FAIL);
    }
    if (direction == SnakeDirection.DIRECTION_RIGHT &&
        heade.x == this._context.xCounts - 1) {
      logUtil.d("game over");
      this._context.updateStatus(GameStatus.GAME_STATUS_FAIL);
    }

    return this._context.isOver();
  }

  bool isGamWin() {
    return this._context.isWin();
  }

  bool isGamStop() {
    print(this._context._status);
    if (this._context._status != GameStatus.GAME_STATUS_CONTINUE) {
      return true;
    }
    return false;
  }

  _SnakePoint _getNewSnakeHead(SnakeDirection direction) {
    _SnakePoint head = this._context.getSnakeHead();
    _SnakePoint newHead = _SnakePoint.NullPoint();
    if (direction == SnakeDirection.DIRECTION_UP) {
      newHead = this._context.getMapPoint(head.x, head.y - 1);
    }

    if (direction == SnakeDirection.DIRECTION_DOWN) {
      newHead = this._context.getMapPoint(head.x, head.y + 1);
    }

    if (direction == SnakeDirection.DIRECTION_LEFT) {
      newHead = this._context.getMapPoint(head.x - 1, head.y);
    }

    if (direction == SnakeDirection.DIRECTION_RIGHT) {
      newHead = this._context.getMapPoint(head.x + 1, head.y);
    }

    return newHead;
  }

  void snakeForward() {
    if (this._context._status != GameStatus.GAME_STATUS_CONTINUE ||
        _isGameOver(this.currentDirection)) {
      logUtil.d("game stop");
      return;
    }
    _SnakePoint nextHead = _getNewSnakeHead(this.currentDirection);
    if (nextHead.isNullPoint()) {
      return;
    }

    bool isEat = nextHead.equals(this._context.getFood());
    this._context.updateSnake(nextHead, isEat);
    if (isEat) {
      this._context.updateFood();
    }
  }

  void generateMap(Canvas canvas, Size size, int xCounts, int yCounts) {
    this.canvas = canvas;
    int YSize = (size.height / yCounts).toInt();
    int XSize = (size.width / xCounts).toInt();
    this.setMap(xCounts, yCounts, XSize, YSize);

    this._context.updateFood();
  }

  void drawMap() {
    var _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    for (int i = 0; i < this._context.xCounts; i++) {
      for (int j = 0; j < this._context.yCounts; j++) {
        PainterUtil.drawPolygon(
            this._context.getPointOffset(this._context.getMapPoint(i, j)),
            this.canvas,
            _paint);
      }
    }
  }

  void drawSnake() {
    var _paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (int i = 0; i < this._context.snake.length; i++) {
      PainterUtil.drawPath(
          this._context.getPointOffset(this._context.snake.elementAt(i)),
          this.canvas,
          _paint);
    }
  }

  void drawFood() {
    var _paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    PainterUtil.drawPath(this._context.getPointOffset(this._context.getFood()),
        this.canvas, _paint);
  }

  void clear() {
    this._context.clear();
    this.currentDirection = SnakeDirection.DIRECTION_UP;
  }
}

class SnakeMainPage extends StatefulWidget {
  const SnakeMainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SnakeMainPage> createState() => _SnakeMainPageState();
}

class _SnakeMainPageState extends State<SnakeMainPage> {
  @override
  Widget build(BuildContext context) {
    return SnakeMap(title: "SnakeMap");
  }
}

class SnakeMap extends StatefulWidget {
  const SnakeMap({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SnakeMap> createState() => _SnakeMapState();
}

class _SnakeMapState extends State<SnakeMap> {
  late Timer _timer;
  int lowSpeedMilliseconds = 500;
  int hightSpeedMilliseconds = 50  ;

  void timerCallback(Timer timer) {
    setState(() {
      g_contoller.snakeForward();
      if (g_contoller.isGamStop()) {
        timer.cancel();
      }
    });
  }

  _SnakeMapState() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), timerCallback);
  }

  void changeSpeed(int milliseconds) {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _timer =
        Timer.periodic(Duration(milliseconds: milliseconds), timerCallback);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: SnakePainter(),
        size: screenUtil.GetPhysicalSize(),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < 0) {
          logUtil.d("up");
          g_contoller.changeDirection(SnakeDirection.DIRECTION_UP);
        }

        if (details.delta.dy > 0) {
          logUtil.d("down");
          g_contoller.changeDirection(SnakeDirection.DIRECTION_DOWN);
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dx < 0) {
          logUtil.d("left");
          g_contoller.changeDirection(SnakeDirection.DIRECTION_LEFT);
        }

        if (details.delta.dx > 0) {
          logUtil.d("right");
          g_contoller.changeDirection(SnakeDirection.DIRECTION_RIGHT);
        }
      },
      onLongPressStart: (LongPressStartDetails details) {
        changeSpeed(hightSpeedMilliseconds);
        logUtil.d("logpress start");
      },
      onLongPressEnd: (LongPressEndDetails details) {
        changeSpeed(lowSpeedMilliseconds);
        logUtil.d("logpress end");
      },
      onDoubleTap: () {
        setState(() {
          g_contoller.clear();
        });
        changeSpeed(lowSpeedMilliseconds);
      },
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}

class SnakePainter extends CustomPainter {
  int yCounts = 50;
  int xCounts = 25;

  @override
  void paint(Canvas canvas, Size size) {
    g_contoller.generateMap(canvas, size, xCounts, yCounts);
    g_contoller.drawMap();
    g_contoller.drawSnake();
    g_contoller.drawFood();
  }

  @override
  bool shouldRepaint(SnakePainter oldDelegate) {
    return this != oldDelegate;
  }
}
