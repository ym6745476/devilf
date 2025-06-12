# الفتح: طريق الانتقام (Al-Fateh: Path of Vengeance)

An Arabic MMORPG game built with Flutter, Dart, and Flame engine.

## Overview

الفتح: طريق الانتقام (Al-Fateh: Path of Vengeance) is a fully-featured MMORPG game with Arabic language support, designed to run on mobile devices and web browsers. The game features a rich fantasy world inspired by Arabic and Islamic history, with deep character progression, guild systems, PvP and PvE combat, and much more.

## Features

- **Character Classes**: Warrior, Mage, Archer, and Assassin with unique skills and abilities
- **Rich Game World**: Cities, forests, deserts, mountains, dungeons with day/night cycle and weather effects
- **Deep Progression**: Level up, acquire skills, enhance equipment, and customize your character
- **Social Systems**: Guilds, parties, chat, trading, and marriage systems
- **Combat**: Real-time combat with skills, combos, and strategic gameplay
- **Quests**: Main storyline and side quests with rewards and progression
- **Economy**: Trading, crafting, and marketplace systems
- **PvP**: Duels, arena battles, and guild wars
- **Full Arabic Support**: Right-to-left text, Arabic UI, and localized content

## Technical Architecture

The game is built using:

- **Flutter & Dart**: For cross-platform UI and game logic
- **Flame Engine**: For 2D game rendering and physics
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **BLoC Pattern**: For state management
- **WebSockets**: For real-time multiplayer communication
- **REST APIs**: For non-real-time game operations
- **Firebase**: For authentication and cloud services

## Project Structure

```
lib/
├── config/                 # Configuration files
├── core/                   # Core utilities and helpers
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   └── utils/              # Utility functions
├── data/                   # Data layer
│   ├── datasources/        # Remote and local data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Use cases
├── game/                   # Game engine and components
│   ├── components/         # Game components
│   │   ├── environment/    # Environment components
│   │   ├── monster/        # Monster components
│   │   ├── npc/            # NPC components
│   │   ├── player/         # Player components
│   │   ├── ui/             # UI components
│   │   └── effects/        # Visual effects
│   ├── systems/            # Game systems
│   └── worlds/             # Game worlds
├── presentation/           # Presentation layer
│   ├── blocs/              # BLoC state management
│   ├── pages/              # App pages
│   └── widgets/            # Reusable widgets
└── main.dart               # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/arabic-mmorpg.git
   ```

2. Install dependencies:
   ```
   cd arabic-mmorpg
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Development

### Building Assets

The game requires various assets (images, audio, etc.) that should be placed in the `assets/` directory. The structure is as follows:

```
assets/
├── images/                 # Game images
│   ├── characters/         # Character sprites
│   ├── monsters/           # Monster sprites
│   ├── maps/               # Map backgrounds
│   ├── items/              # Item icons
│   └── ui/                 # UI elements
├── audio/                  # Audio files
│   ├── music/              # Background music
│   └── sfx/                # Sound effects
├── fonts/                  # Custom fonts
└── maps/                   # Map data files
```

### Server Setup

The game requires a backend server for multiplayer functionality. The server code is available in a separate repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Flame Engine](https://flame-engine.org/)
- [Flutter](https://flutter.dev/)
- [Silkroad Online](https://github.com/kiko19768/Silkroad-online) - For inspiration and reference