import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child:
                isMobile
                    ? _buildMobileFooter(context)
                    : _buildDesktopFooter(context),
          ),
          const SizedBox(height: 40),
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '© ${DateTime.now().year} InfoFlash. Tous droits réservés.',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contenu fictif - Créé à des fins de démonstration',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Info',
                    style: TextStyle(
                      color: Color(0xFFF97316),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Flash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Votre portail d\'information pour rester informé des dernières actualités et tendances.',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Catégories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFooterLink(context, 'Politique', '/category/politique'),
              _buildFooterLink(context, 'Économie', '/category/economie'),
              _buildFooterLink(context, 'Science', '/category/science'),
              _buildFooterLink(context, 'Culture', '/category/culture'),
              _buildFooterLink(context, 'Sport', '/category/sport'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'À propos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFooterLink(context, 'Notre équipe', '/about'),
              _buildFooterLink(context, 'Charte éditoriale', '/ethics'),
              _buildFooterLink(context, 'Contact', '/contact'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Légal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFooterLink(context, 'Conditions d\'utilisation', '/terms'),
              _buildFooterLink(
                context,
                'Politique de confidentialité',
                '/privacy',
              ),
              _buildFooterLink(context, 'Gestion des cookies', '/cookies'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Info',
              style: TextStyle(
                color: Color(0xFFF97316),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Flash',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Votre portail d\'information pour rester informé des dernières actualités et tendances.',
          style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Categories
        const Text(
          'Catégories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildFooterLink(context, 'Politique', '/category/politique'),
            _buildFooterLink(context, 'Économie', '/category/economie'),
            _buildFooterLink(context, 'Science', '/category/science'),
            _buildFooterLink(context, 'Culture', '/category/culture'),
            _buildFooterLink(context, 'Sport', '/category/sport'),
          ],
        ),
        const SizedBox(height: 32),

        // About
        const Text(
          'À propos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildFooterLink(context, 'Notre équipe', '/about'),
            _buildFooterLink(context, 'Charte éditoriale', '/ethics'),
            _buildFooterLink(context, 'Contact', '/contact'),
          ],
        ),
        const SizedBox(height: 32),

        // Legal
        const Text(
          'Légal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildFooterLink(context, 'Conditions d\'utilisation', '/terms'),
            _buildFooterLink(
              context,
              'Politique de confidentialité',
              '/privacy',
            ),
            _buildFooterLink(context, 'Gestion des cookies', '/cookies'),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          title,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
      ),
    );
  }
}
