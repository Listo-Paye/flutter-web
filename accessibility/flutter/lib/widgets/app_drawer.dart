import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Semantics(
        label: 'Menu de navigation principal',
        child: Column(
          children: [
            // En-tête du drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    tooltip: 'Fermer le menu',
                  ),
                ],
              ),
            ),
            
            // Liste des éléments du menu
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard,
                    label: 'Tableau de bord',
                    isSelected: true,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.check_box,
                    label: 'Mes tâches',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.folder,
                    label: 'Projets',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.people,
                    label: 'Équipe',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Calendrier',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Rapports',
                  ),
                ],
              ),
            ),
            
            // Élément d'aide en bas du drawer
            const Divider(),
            _buildDrawerItem(
              context,
              icon: Icons.help_outline,
              label: 'Aide',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

