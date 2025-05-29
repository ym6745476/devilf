import 'package:flutter/material.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/services/game_service.dart';
import 'ui/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final gameService = di.sl<GameService>();
  // Initialize character or other startup logic here if needed
  // await gameService.initializeCharacter('character_id');

  runApp(const SilkroadOnlineApp());
}

class SilkroadOnlineApp extends StatelessWidget {
  const SilkroadOnlineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silkroad Online',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
    );
  }
}
