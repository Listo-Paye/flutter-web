import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_column.dart';
import 'task_form_dialog.dart';

class TaskDashboard extends StatelessWidget {
  const TaskDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasksByStatus = taskProvider.tasksByStatus;
    final filteredTasks = taskProvider.filteredTasks;
    final assignees = taskProvider.assignees;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et bouton d'ajout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Tableau de bord des tâches',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              
              // Bouton d'ajout pour les grands écrans
              if (MediaQuery.of(context).size.width >= 600)
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const TaskFormDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle tâche'),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Filtres et compteur de tâches
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de tâches
                  Semantics(
                    label: '${filteredTasks.length} tâches',
                    child: Text(
                      '${filteredTasks.length} tâche${filteredTasks.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtres
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      // Filtre par statut
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButton<TaskStatus?>(
                            value: taskProvider.filterStatus,
                            hint: const Text('Tous les statuts'),
                            items: [
                              const DropdownMenuItem<TaskStatus?>(
                                value: null,
                                child: Text('Tous les statuts'),
                              ),
                              ...TaskStatus.values.map((status) {
                                return DropdownMenuItem<TaskStatus?>(
                                  value: status,
                                  child: Text(status.label),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              taskProvider.filterByStatus(value);
                            },
                          ),
                        ),
                      ),
                      
                      // Filtre par assigné
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButton<String>(
                            value: taskProvider.filterAssignee.isEmpty ? null : taskProvider.filterAssignee,
                            hint: const Text('Tous les assignés'),
                            items: [
                              const DropdownMenuItem<String>(
                                value: '',
                                child: Text('Tous les assignés'),
                              ),
                              ...assignees.map((assignee) {
                                return DropdownMenuItem<String>(
                                  value: assignee,
                                  child: Text(assignee),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              taskProvider.filterByAssignee(value ?? '');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Colonnes de tâches
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Affichage responsive
                if (constraints.maxWidth < 800) {
                  // Affichage en onglets pour les petits écrans
                  return DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'À faire (${tasksByStatus[TaskStatus.todo]!.length})',
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'En cours (${tasksByStatus[TaskStatus.inProgress]!.length})',
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terminé (${tasksByStatus[TaskStatus.done]!.length})',
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              TaskColumn(
                                status: TaskStatus.todo,
                                tasks: tasksByStatus[TaskStatus.todo]!,
                              ),
                              TaskColumn(
                                status: TaskStatus.inProgress,
                                tasks: tasksByStatus[TaskStatus.inProgress]!,
                              ),
                              TaskColumn(
                                status: TaskStatus.done,
                                tasks: tasksByStatus[TaskStatus.done]!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Affichage en colonnes pour les grands écrans
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TaskColumn(
                          status: TaskStatus.todo,
                          tasks: tasksByStatus[TaskStatus.todo]!,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TaskColumn(
                          status: TaskStatus.inProgress,
                          tasks: tasksByStatus[TaskStatus.inProgress]!,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TaskColumn(
                          status: TaskStatus.done,
                          tasks: tasksByStatus[TaskStatus.done]!,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

