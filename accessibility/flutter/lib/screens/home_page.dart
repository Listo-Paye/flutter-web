import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_footer.dart';
import '../widgets/task_dashboard.dart';
import '../widgets/task_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _skipLinkFocusNode = FocusNode();

  @override
  void dispose() {
    _skipLinkFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTask = context.watch<TaskProvider>().selectedTask;

    return Scaffold(
      key: _scaffoldKey,
      // Skip link pour l'accessibilité
      body: Column(
        children: [
          // Lien d'évitement pour aller directement au contenu principal
          Focus(
            focusNode: _skipLinkFocusNode,
            child: GestureDetector(
              onTap: () {
                // Déplacer le focus vers le contenu principal
                FocusScope.of(context).nextFocus();
              },
              child: Semantics(
                label: "Aller au contenu principal",
                button: true,
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Text(
                      "Aller au contenu principal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenu principal
          Expanded(
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: const Text('Gestion de Tâches Collaboratives'),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  tooltip: 'Menu de navigation',
                ),
                actions: [
                  // Menu utilisateur
                  PopupMenuButton(
                    tooltip: 'Menu utilisateur',
                    offset: const Offset(0, 56),
                    icon: const CircleAvatar(
                      backgroundColor: Color(0xFF3B82F6),
                      child: Text('U', style: TextStyle(color: Colors.white)),
                    ),
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Text('Profil'),
                          ),
                          const PopupMenuItem(
                            value: 'settings',
                            child: Text('Paramètres'),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Text('Déconnexion'),
                          ),
                        ],
                  ),
                ],
              ),
              drawer: const AppDrawer(),
              body: Column(
                children: [
                  // Contenu principal
                  const Expanded(child: TaskDashboard()),

                  // Footer
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Afficher le modal si une tâche est sélectionnée
    if (selectedTask != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => TaskModal(task: selectedTask),
        ).then((_) {
          // Désélectionner la tâche quand le modal est fermé
          Provider.of<TaskProvider>(context, listen: false).selectTask(null);
        });
      });
    }
  }
}
