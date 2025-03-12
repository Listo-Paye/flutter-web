import 'package:flutter/material.dart';

import '../models/task.dart';
import 'task_item.dart';

class TaskColumn extends StatelessWidget {
  final TaskStatus status;
  final List<Task> tasks;
  
  const TaskColumn({
    Key? key,
    required this.status,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Couleur associée au statut
    final Color statusColor = status.getColor(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de la colonne
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  header: true,
                  child: Text(
                    '${status.label} (${tasks.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des tâches
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Semantics(
                      label: 'Aucune tâche',
                      child: const Text(
                        'Aucune tâche',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskItem(task: tasks[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

