I'mimport 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import '../../lib/scripts/quest/quest_system.dart';

void main() {
  group('QuestObjective Tests', () {
    test('Create from YAML data', () {
      final yamlStr = '''
        id: test_objective
        description: Test objective
        type: kill
        target_id: monster_1
        required: 5
        location:
          x: 100.0
          y: 200.0
      ''';
      
      final data = loadYaml(yamlStr);
      final objective = QuestObjective.fromYaml(data);
      
      expect(objective.id, 'test_objective');
      expect(objective.type, 'kill');
      expect(objective.required, 5);
      expect(objective.current, 0);
      expect(objective.location, const Point(100.0, 200.0));
    });

    test('Completion status updates correctly', () {
      final objective = QuestObjective(
        id: 'test',
        description: 'Test',
        type: 'kill',
        targetId: 'monster_1',
        required: 3,
      );
      
      expect(objective.isComplete, false);
      
      objective.current = 2;
      expect(objective.isComplete, false);
      
      objective.current = 3;
      expect(objective.isComplete, true);
      
      objective.current = 4; // Exceeding required amount
      expect(objective.isComplete, true);
    });
  });

  group('QuestRewards Tests', () {
    test('Create from YAML data', () {
      final yamlStr = '''
        experience: 1000
        gold: 500
        items:
          - id: item_1
            amount: 2
          - id: item_2
            amount: 1
      ''';
      
      final data = loadYaml(yamlStr);
      final rewards = QuestRewards.fromYaml(data);
      
      expect(rewards.experience, 1000);
      expect(rewards.gold, 500);
      expect(rewards.items.length, 2);
      expect(rewards.items[0]['id'], 'item_1');
      expect(rewards.items[0]['amount'], 2);
    });
  });

  group('Quest Tests', () {
    test('Create from YAML data', () {
      final yamlStr = '''
        id: quest_1
        title: Test Quest
        description: A test quest
        required_level: 5
        prerequisites: [quest_0]
        objectives:
          - id: obj_1
            description: Kill monsters
            type: kill
            target_id: monster_1
            required: 5
        rewards:
          experience: 1000
          gold: 500
          items:
            - id: item_1
              amount: 1
      ''';
      
      final data = loadYaml(yamlStr);
      final quest = Quest.fromYaml(data);
      
      expect(quest.id, 'quest_1');
      expect(quest.title, 'Test Quest');
      expect(quest.requiredLevel, 5);
      expect(quest.prerequisiteQuests, ['quest_0']);
      expect(quest.objectives.length, 1);
      expect(quest.rewards.experience, 1000);
    });

    test('Quest completion logic', () {
      final quest = Quest(
        id: 'test_quest',
        title: 'Test',
        description: 'Test quest',
        requiredLevel: 1,
        objectives: [
          QuestObjective(
            id: 'obj_1',
            description: 'Test objective',
            type: 'kill',
            targetId: 'monster_1',
            required: 2,
          ),
        ],
        rewards: QuestRewards(
          experience: 100,
          gold: 50,
          items: [],
        ),
        prerequisiteQuests: [],
      );
      
      expect(quest.canComplete, false);
      
      quest.objectives[0].current = 1;
      expect(quest.canComplete, false);
      
      quest.objectives[0].current = 2;
      expect(quest.canComplete, true);
    });
  });

  group('QuestSystem Tests', () {
    late QuestSystem questSystem;
    
    setUp(() {
      questSystem = QuestSystem(maxActiveQuests: 3);
    });

    test('Load quests from YAML', () {
      final yamlStr = '''
        quests:
          - id: quest_1
            title: Test Quest 1
            description: First test quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_1
                required: 3
            rewards:
              experience: 100
              gold: 50
              items: []
          - id: quest_2
            title: Test Quest 2
            description: Second test quest
            required_level: 2
            prerequisites: [quest_1]
            objectives:
              - id: obj_1
                description: Test objective
                type: collect
                target_id: item_1
                required: 2
            rewards:
              experience: 200
              gold: 100
              items: []
      ''';
      
      questSystem.loadQuests(yamlStr);
      
      final availableQuests = questSystem.getAvailableQuests();
      expect(availableQuests.length, 1); // Only quest_1 should be available initially
      expect(availableQuests[0].id, 'quest_1');
    });

    test('Quest acceptance and tracking', () {
      final yamlStr = '''
        quests:
          - id: quest_1
            title: Test Quest
            description: Test quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_1
                required: 3
            rewards:
              experience: 100
              gold: 50
              items: []
      ''';
      
      questSystem.loadQuests(yamlStr);
      
      // Accept quest
      bool accepted = questSystem.acceptQuest('quest_1');
      expect(accepted, true);
      
      var activeQuests = questSystem.getActiveQuests();
      expect(activeQuests.length, 1);
      
      // Update progress
      questSystem.updateProgress('kill', 'monster_1', 2);
      activeQuests = questSystem.getActiveQuests();
      expect(activeQuests[0].objectives[0].current, 2);
      
      // Complete quest
      questSystem.updateProgress('kill', 'monster_1', 1);
      activeQuests = questSystem.getActiveQuests();
      expect(activeQuests.length, 0); // Quest should be completed and removed
    });

    test('Quest prerequisites', () {
      final yamlStr = '''
        quests:
          - id: quest_1
            title: First Quest
            description: First quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_1
                required: 1
            rewards:
              experience: 100
              gold: 50
              items: []
          - id: quest_2
            title: Second Quest
            description: Second quest
            required_level: 1
            prerequisites: [quest_1]
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_2
                required: 1
            rewards:
              experience: 200
              gold: 100
              items: []
      ''';
      
      questSystem.loadQuests(yamlStr);
      
      // Try to accept quest_2 before completing quest_1
      bool accepted = questSystem.acceptQuest('quest_2');
      expect(accepted, false);
      
      // Complete quest_1
      questSystem.acceptQuest('quest_1');
      questSystem.updateProgress('kill', 'monster_1', 1);
      
      // Now quest_2 should be available
      accepted = questSystem.acceptQuest('quest_2');
      expect(accepted, true);
    });

    test('Max active quests limit', () {
      final yamlStr = '''
        quests:
          - id: quest_1
            title: Quest 1
            description: First quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_1
                required: 1
            rewards:
              experience: 100
              gold: 50
              items: []
          - id: quest_2
            title: Quest 2
            description: Second quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_2
                required: 1
            rewards:
              experience: 100
              gold: 50
              items: []
          - id: quest_3
            title: Quest 3
            description: Third quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_3
                required: 1
            rewards:
              experience: 100
              gold: 50
              items: []
          - id: quest_4
            title: Quest 4
            description: Fourth quest
            required_level: 1
            objectives:
              - id: obj_1
                description: Test objective
                type: kill
                target_id: monster_4
                required: 1
            rewards:
              experience: 100
              gold: 50
              items: []
      ''';
      
      questSystem.loadQuests(yamlStr);
      
      // Accept up to max limit
      expect(questSystem.acceptQuest('quest_1'), true);
      expect(questSystem.acceptQuest('quest_2'), true);
      expect(questSystem.acceptQuest('quest_3'), true);
      
      // Try to accept one more
      expect(questSystem.acceptQuest('quest_4'), false);
      
      // Complete one quest
      questSystem.updateProgress('kill', 'monster_1', 1);
      
      // Should be able to accept another quest now
      expect(questSystem.acceptQuest('quest_4'), true);
    });
  });
