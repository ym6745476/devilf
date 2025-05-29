import 'package:flutter/material.dart';
// Removed unused import 'package:provider/provider.dart';
import 'game_interface.dart';
import '../core/injection/injection_container.dart' as di;
import '../core/services/game_service.dart';
import '../scripts/game_engine.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  void _startGame(BuildContext context) async {
    final gameService = di.sl<GameService>();
    // For demonstration, initialize a character with a dummy id
    await gameService.initializeCharacter('default_character_id');

    final gameEngine = GameEngine(gameService: gameService);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameInterface(gameEngine: gameEngine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Al-Fath: Path of Revenge',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              _buildMenuButton(
                context,
                'Start Game',
                () => _startGame(context),
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Settings',
                () {
                  // TODO: Implement settings
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Exit',
                () {
                  // TODO: Implement exit
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
