import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;

  const TaskFormDialog({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assigneeController = TextEditingController();

  TaskStatus _status = TaskStatus.todo;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  final FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Si une tâche est fournie, initialiser les champs avec ses valeurs
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _status = widget.task!.status;
      _assigneeController.text = widget.task!.assignee;
      _dueDate = widget.task!.dueDate;
    }

    // Focus sur le champ de titre au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  // Sélectionner une date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Sélectionner une date d\'échéance',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  // Soumettre le formulaire
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task != null) {
        // Mettre à jour une tâche existante
        taskProvider.updateTask(
          widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          status: _status,
          assignee: _assigneeController.text,
          dueDate: _dueDate,
        );
      } else {
        // Créer une nouvelle tâche
        taskProvider.addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          status: _status,
          assignee: _assigneeController.text,
          dueDate: _dueDate,
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task != null ? 'Modifier la tâche' : 'Nouvelle tâche'),
      semanticLabel: "Formulaire de tâche",
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Entrez le titre de la tâche',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Entrez une description (optionnel)',
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Statut
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Statut'),
                items:
                    TaskStatus.values.map((status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Assigné
              TextFormField(
                controller: _assigneeController,
                decoration: const InputDecoration(
                  labelText: 'Assigné à',
                  hintText: 'Entrez le nom de la personne assignée',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'assigné est requis';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Date d'échéance
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date d\'échéance',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_dueDate)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.task != null ? 'Mettre à jour' : 'Créer'),
        ),
      ],
    );
  }
}
