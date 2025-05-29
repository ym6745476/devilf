import 'dart:async';

class GameEvent {
  final String id;
  final String name;
  final DateTime startTime;
  final Duration duration;
  final bool isBossEvent;
  bool isActive = false;

  GameEvent({
    required this.id,
    required this.name,
    required this.startTime,
    required this.duration,
    this.isBossEvent = false,
  });

  bool get hasStarted => DateTime.now().isAfter(startTime);
  bool get hasEnded => DateTime.now().isAfter(startTime.add(duration));
}

class EventSystem {
  final List<GameEvent> _events = [];
  Timer? _timer;

  EventSystem() {
    _timer = Timer.periodic(Duration(seconds: 30), (_) => _checkEvents());
  }

  void addEvent(GameEvent event) {
    _events.add(event);
  }

  void removeEvent(String eventId) {
    _events.removeWhere((e) => e.id == eventId);
  }

  List<GameEvent> get activeEvents =>
      _events.where((e) => e.isActive && !e.hasEnded).toList();

  void _checkEvents() {
    final now = DateTime.now();
    for (var event in _events) {
      if (!event.isActive && event.hasStarted && !event.hasEnded) {
        event.isActive = true;
        _onEventStart(event);
      } else if (event.isActive && event.hasEnded) {
        event.isActive = false;
        _onEventEnd(event);
      }
    }
  }

  void _onEventStart(GameEvent event) {
    // TODO: Notify players, spawn bosses, etc.
  }

  void _onEventEnd(GameEvent event) {
    // TODO: Cleanup event, notify players, distribute rewards
  }

  void dispose() {
    _timer?.cancel();
  }
}
