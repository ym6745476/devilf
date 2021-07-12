import 'dart:ui';

import 'package:example/game_scene.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() async {

  // 游戏场景
  GameScene gameScene = GameScene();
  runApp(MyApp(gameScene));

}

class MyApp extends StatelessWidget {

  GameScene _gameScene;

  MyApp(this._gameScene);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Devilf',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        body:_gameScene,
      ),
    );
  }

}