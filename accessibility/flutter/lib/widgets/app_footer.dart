import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Semantics(
        label: 'Pied de page',
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© $currentYear Gestion de Tâches Collaboratives',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
                
                // Liens du footer pour les grands écrans
                Wrap(
                  spacing: 24,
                  children: [
                    _buildFooterLink(context, 'Confidentialité'),
                    _buildFooterLink(context, 'Conditions d\'utilisation'),
                    _buildFooterLink(context, 'Contact'),
                  ],
                ),
              ],
            ),
            
            // Liens du footer pour les petits écrans
            MediaQuery.of(context).size.width < 600
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Wrap(
                      spacing: 24,
                      children: [
                        _buildFooterLink(context, 'Confidentialité'),
                        _buildFooterLink(context, 'Conditions d\'utilisation'),
                        _buildFooterLink(context, 'Contact'),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFooterLink(BuildContext context, String label) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: () {},
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

