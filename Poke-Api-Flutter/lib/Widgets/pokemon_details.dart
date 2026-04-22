import 'package:flutter/material.dart';
import '../Design/themes.dart';
import '../Preferences/shared_preferences.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FavoriteService.isFavorite(widget.pokemon['id']);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    await FavoriteService.toggleFavorite(widget.pokemon['id']);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final types = List<String>.from(widget.pokemon['types']);
    final stats = List<Map<String, dynamic>>.from(widget.pokemon['stats']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemon['name'][0].toUpperCase() +
              widget.pokemon['name'].substring(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? colors.onError : Colors.grey,
              size: 26,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
        backgroundColor: colors.error,
        elevation: 2,
      ),

      // --- resto del código igual ---
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.network(
                widget.pokemon['image'],
                height: 180,
                errorBuilder: (context, error, _) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: types.map((type) {
                final color = getTypeColor(type);
                final icon = getTypeIcon(type);
                final formatted = type[0].toUpperCase() + type.substring(1);
                return Chip(
                  avatar: Icon(icon, color: Colors.white, size: 16),
                  backgroundColor: color,
                  label: Text(formatted,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final stat = stats[index];
                  final name = stat['name'] as String;
                  final baseStat = stat['base_stat'] as int;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            name.replaceAll('-', ' '),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: baseStat / 200.0,
                              minHeight: 10,
                              backgroundColor: colors.surfaceVariant,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          baseStat.toString(),
                          style:
                          const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
