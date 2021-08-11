import 'package:example/scene/game_scene.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() async {
  /// 游戏场景
  GameScene gameScene = GameScene();

  /// 运行游戏
  runApp(MainApp(gameScene));
}

/// 主界面
class MainApp extends StatelessWidget {

  /// 游戏场景
  final GameScene _gameScene;

  /// 创建主界面
  MainApp(this._gameScene);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevilF',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        body: _gameScene,
      ),
    );
  }
}
