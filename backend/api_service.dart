class ApiService {
  // Simulated user database
  final Map<String, String> _users = {};

  // Register a new user
  bool register(String username, String password) {
    if (_users.containsKey(username)) {
      return false; // User already exists
    }
    _users[username] = password;
    return true;
  }

  // Login user
  bool login(String username, String password) {
    return _users[username] == password;
  }

  // Other account management methods can be added here
}
