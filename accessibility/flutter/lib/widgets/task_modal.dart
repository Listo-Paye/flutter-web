import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_form_dialog.dart';

class TaskModal extends StatefulWidget {
  final Task task;

  const TaskModal({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskModal> createState() => _TaskModalState();
}

class _TaskModalState extends State<TaskModal> {
  bool _confirmDelete = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final taskProvider = Provider.of<TaskProvider>(context);

    // Récupérer la tâche mise à jour
    final task = taskProvider.tasks.firstWhere(
      (t) => t.id == widget.task.id,
      orElse: () => widget.task,
    );

    return AlertDialog(
      title: Text(task.title, style: Theme.of(context).textTheme.titleLarge),
      semanticLabel: "Détails de la tâche ${task.title}",
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge de statut
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: task.status.getColor(context).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                task.status.label,
                style: TextStyle(
                  color: task.status.getColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              task.description.isEmpty
                  ? 'Aucune description'
                  : task.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            // Informations sur la tâche
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigné à',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(task.assignee),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date d\'échéance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(dateFormat.format(task.dueDate)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date de création
            const Text(
              'Créée le',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(dateFormat.format(task.createdAt)),

            const SizedBox(height: 24),

            // Changer le statut
            const Text(
              'Changer le statut',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  TaskStatus.values.map((status) {
                    final isSelected = task.status == status;
                    return ChoiceChip(
                      label: Text(status.label),
                      selected: isSelected,
                      selectedColor: status.getColor(context).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? status.getColor(context)
                                : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          taskProvider.updateTask(task.id, status: status);
                        }
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        // Bouton de suppression
        if (_confirmDelete)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirmer la suppression ?',
                style: TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () {
                  taskProvider.deleteTask(task.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Oui'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _confirmDelete = false;
                  });
                },
                child: const Text('Non'),
              ),
            ],
          )
        else
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Supprimer la tâche',
            onPressed: () {
              setState(() {
                _confirmDelete = true;
              });
            },
          ),

        const Spacer(),

        // Boutons d'action
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) => TaskFormDialog(task: task),
            );
          },
          child: const Text('Modifier'),
        ),
      ],
    );
  }
}
