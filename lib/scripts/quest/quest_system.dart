import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'dart:math' as math;

/// Represents a quest objective
class QuestObjective {
  final String id;
  final String description;
  final String type; // kill, collect, talk, etc.
  final String targetId; // monster ID, item ID, or NPC ID
  final int required;
  int current;
  Offset? location; // Target location for auto-walk
  
  QuestObjective({
    required this.id,
    required this.description,
    required this.type,
    required this.targetId,
    required this.required,
    this.current = 0,
    this.location,
  });
  
  bool get isComplete => current >= required;
  
  factory QuestObjective.fromYaml(YamlMap data) {
    return QuestObjective(
      id: data['id'],
      description: data['description'],
      type: data['type'],
      targetId: data['target_id'],
      required: data['required'],
      location: data['location'] != null 
          ? Offset(data['location']['x'].toDouble(), data['location']['y'].toDouble())
          : null,
    );
  }
}

/// Represents quest rewards
class QuestRewards {
  final int experience;
  final int gold;
  final List<Map<String, dynamic>> items; // [{id: "item_id", amount: 1}]
  
  QuestRewards({
    required this.experience,
    required this.gold,
    required this.items,
  });
  
  factory QuestRewards.fromYaml(YamlMap data) {
    return QuestRewards(
      experience: data['experience'],
      gold: data['gold'],
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
    );
  }
}

/// Represents a game quest
class Quest {
  final String id;
  final String title;
  final String description;
  final int requiredLevel;
  final List<QuestObjective> objectives;
  final QuestRewards rewards;
  final List<String> prerequisiteQuests;
  bool isCompleted;
  bool isActive;
  
  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredLevel,
    required this.objectives,
    required this.rewards,
    required this.prerequisiteQuests,
    this.isCompleted = false,
    this.isActive = false,
  });
  
  bool get canComplete => objectives.every((obj) => obj.isComplete);
  
  factory Quest.fromYaml(YamlMap data) {
    return Quest(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      requiredLevel: data['required_level'],
      objectives: (data['objectives'] as YamlList)
          .map((obj) => QuestObjective.fromYaml(obj))
          .toList(),
      rewards: QuestRewards.fromYaml(data['rewards']),
      prerequisiteQuests: List<String>.from(data['prerequisites'] ?? []),
    );
  }
}

/// Manages the quest system
class QuestSystem {
  final Map<String, Quest> _quests = {};
  final List<Quest> _activeQuests = [];
  final int maxActiveQuests;
  
  // Callbacks for UI updates
  final Function(Quest)? onQuestActivated;
  final Function(Quest)? onQuestCompleted;
  final Function(Quest, QuestObjective)? onObjectiveUpdated;
  
  QuestSystem({
    this.maxActiveQuests = 20,
    this.onQuestActivated,
    this.onQuestCompleted,
    this.onObjectiveUpdated,
  });
  
  /// Load quests from YAML data
  void loadQuests(String yamlContent) {
    final questsData = loadYaml(yamlContent);
    for (var questData in questsData['quests']) {
      var quest = Quest.fromYaml(questData);
      _quests[quest.id] = quest;
    }
  }
  
  /// Accept a new quest
  bool acceptQuest(String questId) {
    if (_activeQuests.length >= maxActiveQuests) {
      return false;
    }
    
    var quest = _quests[questId];
    if (quest == null || quest.isActive || quest.isCompleted) {
      return false;
    }
    
    // Check prerequisites
    if (!_checkPrerequisites(quest)) {
      return false;
    }
    
    quest.isActive = true;
    _activeQuests.add(quest);
    onQuestActivated?.call(quest);
    return true;
  }
  
  /// Update quest progress
  void updateProgress(String type, String targetId, [int amount = 1]) {
    for (var quest in _activeQuests) {
      for (var objective in quest.objectives) {
        if (objective.type == type && objective.targetId == targetId) {
          objective.current = math.min(objective.required, objective.current + amount);
          onObjectiveUpdated?.call(quest, objective);
          
          // Check if quest can be completed
          if (quest.canComplete) {
            completeQuest(quest.id);
          }
        }
      }
    }
  }
  
  /// Complete a quest and grant rewards
  bool completeQuest(String questId) {
    var quest = _quests[questId];
    if (quest == null || !quest.isActive || !quest.canComplete) {
      return false;
    }
    
    quest.isActive = false;
    quest.isCompleted = true;
    _activeQuests.remove(quest);
    onQuestCompleted?.call(quest);
    return true;
  }
  
  /// Get the next objective location for auto-walk
  Offset? getNextObjectiveLocation(String questId) {
    var quest = _quests[questId];
    if (quest == null || !quest.isActive) {
      return null;
    }
    
    // Find first incomplete objective with a location
    for (var objective in quest.objectives) {
      if (!objective.isComplete && objective.location != null) {
        return objective.location;
      }
    }
    
    return null;
  }
  
  /// Check if all prerequisite quests are completed
  bool _checkPrerequisites(Quest quest) {
    return quest.prerequisiteQuests.every((prereqId) {
      var prereqQuest = _quests[prereqId];
      return prereqQuest != null && prereqQuest.isCompleted;
    });
  }
  
  /// Get all available quests
  List<Quest> getAvailableQuests() {
    return _quests.values.where((quest) => 
      !quest.isActive && 
      !quest.isCompleted && 
      _checkPrerequisites(quest)
    ).toList();
  }
  
  /// Get all active quests
  List<Quest> getActiveQuests() {
    return List.from(_activeQuests);
  }
}
