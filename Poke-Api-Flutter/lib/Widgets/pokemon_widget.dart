import 'package:flutter/material.dart';
import 'package:practicas/API/get_api.dart';
import 'package:practicas/Widgets/pokemon_details.dart';
import 'package:practicas/Widgets/pokemon_widget.dart';

import '../Design/themes.dart';

class PokemonGrid extends StatelessWidget {
  final String searchQuery;
  final List<String> selectPokemon;

  const PokemonGrid({
    super.key,
    this.searchQuery = '',
    this.selectPokemon = const [],
  });
//lazyloading
  @override
  Widget build(BuildContext context) {

    final PokemonService service = PokemonService();
    return FutureBuilder<List<Map<String,dynamic>>>(
      future: service.getPokemons(limit: 50),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final pokemons = snapshot.data ?? [];

        //  Filtrado por nombre y tipo
        final filtered = pokemons.where((pokemon) {
          final name = pokemon['name']?.toLowerCase() ?? '';
          final matchesSearch = name.contains(searchQuery);

          // Si no hay tipos seleccionados, solo aplica la búsqueda
          if (selectPokemon.isEmpty) return matchesSearch;

          //  Los tipos ya vienen precargados como List<String>
          final pokemonTypes = (pokemon['types'] as List<dynamic>?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
              [];

          // Si al menos un tipo coincide
          final matchesType =
          selectPokemon.any((type) => pokemonTypes.contains(type));

          return matchesSearch && matchesType;
        }).toList();

        // Si no hay resultados
        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'No hay registro de tu Pokémon :(',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        // Mostrar grid de pokémones
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columnas
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),

              //Cambio para las Cards
            itemBuilder: (context, index) {
              final pokemon = filtered[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PokemonDetailScreen(pokemon: pokemon),
                    ),
                  );
                },
                child: PokemonCard(
                  name: pokemon['name'],
                  imageUrl: pokemon['image'],
                  pokemonId: pokemon['id'],
                  types: List<String>.from(pokemon['types']),
                ),
              );
            },


          ),
        );
      },
    );
  }
}

class PokemonCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String pokemonId;
  final List<String> types;

  const PokemonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.pokemonId,
    required this.types,
  });

  @override
  State<PokemonCard> createState() => PokemonCardState();
}

class PokemonCardState extends State<PokemonCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen del Pokémon
              Expanded(
                child: Center(
                  //padding: const EdgeInsets.all(8.0),
                  //padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stakeTrace) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //ID
              Text(
                '#${widget.pokemonId}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),


              // Nombre
              Text(
                widget.name[0].toUpperCase() + widget.name.substring(1),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              // Tipos (ya cargados)
              SizedBox(
                height: 28,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: widget.types.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                  itemBuilder: (context, index) {
                    final type = widget.types[index];
                    final color = getTypeColor(type);
                    final icon = getTypeIcon(type);
                    final formattedType =
                        type[0].toUpperCase() + type.substring(1);

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 12, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            formattedType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Botón favorito

        ],
      ),
    );
  }
}
