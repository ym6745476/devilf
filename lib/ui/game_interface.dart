import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class GameInterface extends StatelessWidget {
  const GameInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Game world view takes the full screen
        const GameWorldView(),
        
        // Overlay UI elements
        SafeArea(
          child: Stack(
            children: const [
              // Top bar with player info
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PlayerInfoBar(),
              ),
              
              // Mini-map in top-right corner
              Positioned(
                top: 10,
                right: 10,
                child: MiniMap(),
              ),
              
              // Quest tracker in top-right
              Positioned(
                top: 160,
                right: 10,
                child: QuestTracker(),
              ),
              
              // Virtual joystick in bottom-left
              Positioned(
                left: 30,
                bottom: 30,
                child: MovementJoystick(),
              ),
              
              // Action buttons in bottom-right
              Positioned(
                right: 30,
                bottom: 30,
                child: ActionButtons(),
              ),
              
              // Auto-mode toggle
              Positioned(
                right: 10,
                bottom: 200,
                child: AutoModeToggle(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GameWorldView extends StatelessWidget {
  const GameWorldView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // This will be replaced with actual game rendering
      color: Colors.green.shade900,
    );
  }
}

class PlayerInfoBar extends StatelessWidget {
  const PlayerInfoBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text('Lv.1'),
          ),
          const SizedBox(width: 8),
          // Health and Mana bars
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBar(color: Colors.red, value: 0.8, label: 'HP 800/1000'),
                const SizedBox(height: 4),
                _buildBar(color: Colors.blue, value: 0.6, label: 'MP 600/1000'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Experience bar
          Container(
            width: 100,
            padding: const EdgeInsets.all(4),
            child: _buildBar(color: Colors.yellow, value: 0.45, label: '45%'),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({
    required Color color,
    required double value,
    required String label,
  }) {
    return Stack(
      children: [
        // Background
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Fill
        FractionallySizedBox(
          widthFactor: value,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Label
        Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class MiniMap extends StatelessWidget {
  const MiniMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: const Center(
        child: Text(
          'Mini Map',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class QuestTracker extends StatelessWidget {
  const QuestTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Current Quests',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: Colors.white24),
          QuestObjectiveItem(
            quest: 'Monster Hunt',
            objective: 'Kill Spiders (3/5)',
          ),
        ],
      ),
    );
  }
}

class QuestObjectiveItem extends StatelessWidget {
  final String quest;
  final String objective;

  const QuestObjectiveItem({
    Key? key,
    required this.quest,
    required this.objective,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quest,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 12,
            ),
          ),
          Text(
            objective,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class MovementJoystick extends StatelessWidget {
  const MovementJoystick({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Joystick(
        onStickDragEnd: () {
          // Stop character movement
        },
        listener: (details) {
          // Update character movement
          // details.x and details.y contain the joystick position
        },
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: Icons.flash_on,
              color: Colors.yellow,
              onPressed: () {
                // Trigger skill 1
              },
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.local_fire_department,
              color: Colors.red,
              onPressed: () {
                // Trigger skill 2
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: Icons.shield,
              color: Colors.blue,
              onPressed: () {
                // Trigger skill 3
              },
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.healing,
              color: Colors.green,
              onPressed: () {
                // Use healing item
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class AutoModeToggle extends StatelessWidget {
  const AutoModeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Auto',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: false, // Connect to state management
            onChanged: (value) {
              // Toggle auto mode
            },
          ),
        ],
      ),
    );
  }
}
