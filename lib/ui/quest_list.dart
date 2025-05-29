import 'package:flutter/material.dart';
import '../scripts/quest/quest_system.dart';

class QuestListWidget extends StatelessWidget {
  final QuestSystem questSystem;
  final Function(String) onQuestSelected;

  const QuestListWidget({
    Key? key,
    required this.questSystem,
    required this.onQuestSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeQuests = questSystem.getActiveQuests();

    return ListView.builder(
      itemCount: activeQuests.length,
      itemBuilder: (context, index) {
        final quest = activeQuests[index];
        return ListTile(
          title: Text(quest.title),
          subtitle: Text(quest.description),
          trailing: quest.canComplete
              ? Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () {
            onQuestSelected(quest.id);
          },
        );
      },
    );
  }
}
