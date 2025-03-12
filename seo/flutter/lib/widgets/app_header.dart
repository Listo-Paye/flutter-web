import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final List<Map<String, String>> categories = [
    {'name': 'Politique', 'slug': 'politique'},
    {'name': 'Économie', 'slug': 'economie'},
    {'name': 'Science', 'slug': 'science'},
    {'name': 'Culture', 'slug': 'culture'},
    {'name': 'Sport', 'slug': 'sport'},
  ];

  bool isSearchExpanded = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF97316),
              ),
            ),
            Text('Flash', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        if (!isMobile) ...[
          // Desktop navigation
          ...categories
              .map(
                (category) => TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/category/${category['slug']}',
                    );
                  },
                  child: Text(
                    category['name']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),

          const SizedBox(width: 8),

          // Search bar
          if (!isSearchExpanded)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearchExpanded = true;
                });
              },
            )
          else
            Container(
              width: 200,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchExpanded = false;
                        searchController.clear();
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

          const SizedBox(width: 8),

          // Theme toggle
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ] else ...[
          // Mobile: just show search and menu buttons
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearchDelegate());
            },
          ),

          // Theme toggle
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),

          // Menu for mobile
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              Navigator.pushNamed(context, '/category/$value');
            },
            itemBuilder: (BuildContext context) {
              return categories.map((category) {
                return PopupMenuItem<String>(
                  value: category['slug'],
                  child: Text(category['name']!),
                );
              }).toList();
            },
          ),
        ],
      ],
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Center(child: Text('Résultats pour: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return const Center(child: Text('Commencez à taper pour rechercher...'));
  }
}
