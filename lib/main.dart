import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'ui/main_menu.dart';
import 'ui/game_interface.dart';
import 'localization/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: const GameApp(),
    ),
  );
}

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silkroad Online',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Custom theme for game UI
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const GameRouter(),
    );
  }
}

class GameRouter extends StatelessWidget {
  const GameRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        if (!authState.isLoggedIn) {
          return const MainMenu();
        }
        
        return Consumer<GameState>(
          builder: (context, gameState, child) {
            if (gameState.isLoading) {
              return const LoadingScreen();
            }
            
            return const GameInterface();
          },
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameState with ChangeNotifier {
  bool _isLoading = true;
  Map<String, dynamic>? _currentCharacter;
  String _currentMap = 'lxd';
  bool _autoModeEnabled = false;
  
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get currentCharacter => _currentCharacter;
  String get currentMap => _currentMap;
  bool get autoModeEnabled => _autoModeEnabled;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void setCurrentCharacter(Map<String, dynamic> character) {
    _currentCharacter = character;
    notifyListeners();
  }
  
  void setCurrentMap(String mapId) {
    _currentMap = mapId;
    notifyListeners();
  }
  
  void toggleAutoMode() {
    _autoModeEnabled = !_autoModeEnabled;
    notifyListeners();
  }
  
  // Game state initialization
  Future<void> initializeGame() async {
    setLoading(true);
    
    try {
      // Load game configurations
      await Future.delayed(const Duration(seconds: 2)); // Simulated loading
      
      // Initialize game systems
      // TODO: Initialize AI, Combat, Quest systems
      
      setLoading(false);
    } catch (e) {
      print('Error initializing game: $e');
      setLoading(false);
    }
  }
}

class AuthState with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  List<Map<String, dynamic>> _characters = [];
  
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  List<Map<String, dynamic>> get characters => _characters;
  
  Future<bool> login(String username, String password) async {
    try {
      // TODO: Implement actual login logic
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      
      _isLoggedIn = true;
      _userId = 'user_123';
      _loadCharacters();
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _characters = [];
    notifyListeners();
  }
  
  Future<void> _loadCharacters() async {
    // TODO: Load characters from backend
    _characters = [
      {
        'id': '1',
        'name': 'Hero1',
        'level': 10,
        'class': 'Warrior',
      },
      {
        'id': '2',
        'name': 'Mage1',
        'level': 8,
        'class': 'Mage',
      },
    ];
    notifyListeners();
  }
  
  Future<bool> createCharacter(Map<String, dynamic> characterData) async {
    try {
      // TODO: Implement actual character creation
      await Future.delayed(const Duration(seconds: 1));
      
      _characters.add({
        'id': DateTime.now().toString(),
        ...characterData,
      });
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Character creation error: $e');
      return false;
    }
  }
}
