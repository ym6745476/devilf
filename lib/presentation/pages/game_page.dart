import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';
import 'package:arabic_mmorpg/presentation/widgets/game_hud.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late GameEngine _gameEngine;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    // إنشاء محرك اللعبة
    _gameEngine = GameEngine();
    
    // محاكاة تحميل موارد اللعبة
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل عالم اللعبة...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // محرك اللعبة
          GameWidget(
            game: _gameEngine,
          ),
          
          // واجهة المستخدم أثناء اللعب
          const GameHUD(),
        ],
      ),
    );
  }
}