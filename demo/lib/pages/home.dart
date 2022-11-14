
import 'package:demo/utils/file.dart';
import 'package:flutter/cupertino.dart';

import '../utils/random.dart';
import 'games/snake.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    fileUtil;
     return Container(child: SnakeMainPage(title: 'snake'));
  }
}
