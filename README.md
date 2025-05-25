# Silkroad Online

A Flutter-based MMORPG game inspired by "Al-Fath: Path of Revenge", built using the Silkroad-online project as a foundation.

## Project Structure

```
/
├── lib/
│   ├── game_data/      # Game data and configurations
│   │   ├── config/     # Game settings and configurations
│   │   └── quests/     # Quest definitions
│   ├── scripts/        # Game logic
│   │   ├── ai/        # AI behavior systems
│   │   ├── combat/    # Combat mechanics
│   │   └── quest/     # Quest management
│   ├── ui/            # User interface components
│   └── main.dart      # Application entry point
└── example/           # Example implementation and assets

```

## Features

- **Character Control**
  - Virtual joystick for mobile
  - WASD controls for web
  - Auto-walk system for quests

- **Combat System**
  - Auto-attack mode
  - Skill system
  - Combat effects
  - PvP support

- **Quest System**
  - Quest tracking
  - Auto-walk to objectives
  - Reward system
  - Daily quests

- **User Interface**
  - Responsive design for web and mobile
  - Main menu with login/register
  - Character creation and selection
  - In-game HUD with minimap
  - Inventory system
  - Quest tracker

- **Advanced Systems**
  - VIP system with benefits
  - Guild system
  - PvP/Arena system
  - Event system

## Getting Started

1. Install Flutter and set up your development environment
   ```bash
   flutter pub get
   ```

2. Run the application
   ```bash
   flutter run
   ```

## Development

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Configuration
Game configuration can be found in:
```
lib/game_data/config/game_config.yaml
```

### Adding New Content

#### Quests
Add new quests in:
```
lib/game_data/quests/initial_quests.yaml
```

#### AI Behaviors
Extend the AIController class in:
```
lib/scripts/ai/ai_controller.dart
```

#### Combat Skills
Add new skills through the combat system in:
```
lib/scripts/combat/combat_system.dart
```

## Testing

Run tests using:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Based on the Silkroad-online project
- Inspired by "Al-Fath: Path of Revenge"
