import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  MenuState _currentState = MenuState.login;

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
        child: SafeArea(
          child: Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildCurrentView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentState) {
      case MenuState.login:
        return LoginView(
          onRegister: () => setState(() => _currentState = MenuState.register),
          onSuccess: () => setState(() => _currentState = MenuState.characterSelect),
        );
      case MenuState.register:
        return RegisterView(
          onBack: () => setState(() => _currentState = MenuState.login),
          onSuccess: () => setState(() => _currentState = MenuState.login),
        );
      case MenuState.characterSelect:
        return CharacterSelectView(
          onBack: () => setState(() => _currentState = MenuState.login),
          onCreateCharacter: () => setState(() => _currentState = MenuState.characterCreate),
          onCharacterSelected: (character) {
            // Start game with selected character
          },
        );
      case MenuState.characterCreate:
        return CharacterCreateView(
          onBack: () => setState(() => _currentState = MenuState.characterSelect),
          onSuccess: () => setState(() => _currentState = MenuState.characterSelect),
        );
    }
  }
}

enum MenuState {
  login,
  register,
  characterSelect,
  characterCreate,
}

class LoginView extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onSuccess;

  const LoginView({
    Key? key,
    required this.onRegister,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Welcome to Silkroad Online',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        _buildTextField(
          hint: 'Username',
          icon: Icons.person,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          hint: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSuccess,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onRegister,
          child: const Text(
            'Create New Account',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class RegisterView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const RegisterView({
    Key? key,
    required this.onBack,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Create New Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        _buildTextField(
          hint: 'Username',
          icon: Icons.person,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          hint: 'Email',
          icon: Icons.email,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          hint: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          hint: 'Confirm Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Back to Login',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: onSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ],
    );
  }
}

class CharacterSelectView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateCharacter;
  final Function(Map<String, dynamic>) onCharacterSelected;

  const CharacterSelectView({
    Key? key,
    required this.onBack,
    required this.onCreateCharacter,
    required this.onCharacterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Select Character',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: 3, // Replace with actual character count
            itemBuilder: (context, index) {
              return _buildCharacterCard(
                name: 'Character ${index + 1}',
                level: 10,
                className: 'Warrior',
                onSelect: () => onCharacterSelected({'id': index}),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: onCreateCharacter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Create New Character'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCharacterCard({
    required String name,
    required int level,
    required String className,
    required VoidCallback onSelect,
  }) {
    return Card(
      color: Colors.black45,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Level $level $className',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: ElevatedButton(
          onPressed: onSelect,
          child: const Text('Select'),
        ),
      ),
    );
  }
}

class CharacterCreateView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const CharacterCreateView({
    Key? key,
    required this.onBack,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Create Character',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          hint: 'Character Name',
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
        const Text(
          'Select Class',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildClassOption(
              name: 'Warrior',
              icon: Icons.shield,
              isSelected: true,
            ),
            _buildClassOption(
              name: 'Mage',
              icon: Icons.auto_fix_high,
              isSelected: false,
            ),
            _buildClassOption(
              name: 'Archer',
              icon: Icons.gps_fixed,
              isSelected: false,
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: onSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClassOption({
    required String name,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.black45,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTextField({
  required String hint,
  required IconData icon,
  bool isPassword = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    ),
  );
}
