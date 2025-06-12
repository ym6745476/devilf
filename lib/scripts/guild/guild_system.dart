class Guild {
  final String id;
  final String name;
  final String leaderId;
  final List<String> memberIds;
  final List<String> events;

  Guild({
    required this.id,
    required this.name,
    required this.leaderId,
    List<String>? memberIds,
    List<String>? events,
  })  : memberIds = memberIds ?? [],
        events = events ?? [];

  void addMember(String playerId) {
    if (!memberIds.contains(playerId)) {
      memberIds.add(playerId);
    }
  }

  void removeMember(String playerId) {
    memberIds.remove(playerId);
  }

  void addEvent(String eventId) {
    if (!events.contains(eventId)) {
      events.add(eventId);
    }
  }

  void removeEvent(String eventId) {
    events.remove(eventId);
  }
}

class GuildSystem {
  final Map<String, Guild> _guilds = {};

  void createGuild(String id, String name, String leaderId) {
    if (_guilds.containsKey(id)) return;
    _guilds[id] = Guild(id: id, name: name, leaderId: leaderId);
  }

  void disbandGuild(String id) {
    _guilds.remove(id);
  }

  Guild? getGuild(String id) {
    return _guilds[id];
  }

  void joinGuild(String guildId, String playerId) {
    final guild = _guilds[guildId];
    guild?.addMember(playerId);
  }

  void leaveGuild(String guildId, String playerId) {
    final guild = _guilds[guildId];
    guild?.removeMember(playerId);
  }

  List<Guild> getAllGuilds() {
    return _guilds.values.toList();
  }
}
