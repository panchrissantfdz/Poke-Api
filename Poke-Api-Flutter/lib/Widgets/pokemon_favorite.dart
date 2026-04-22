import 'package:flutter/material.dart';
import 'package:practicas/API/get_api.dart';
import 'package:practicas/Widgets/pokemon_details.dart';
import 'package:practicas/Widgets/pokemon_widget.dart';
import '../Preferences/shared_preferences.dart';
import '../Design/themes.dart';



class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final service = PokemonService();
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<String>>(
      future: FavoriteService.getFavorites(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoriteIds = snapshot.data!;
        if (favoriteIds.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: colorScheme.error,
              elevation: 2,
            ),
            body: Padding(padding: const EdgeInsets.all(8.0),
              child:
              Center(
                child: Text(
                  'No hay registro de tu Pokémon :(',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              )
            ),
          );
        }



        return FutureBuilder<List<Map<String, dynamic>>>(
          future: service.getPokemons(limit: 100),
          builder: (context, snapshot2) {
            if (!snapshot2.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final pokemons = snapshot2.data!;
            final favorites = pokemons
                .where((p) => favoriteIds.contains(p['id']))
                .toList();

            print(favorites);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Pokémon Favoritos'),
                backgroundColor: colorScheme.error,
                elevation: 2,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: favorites.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final pokemon = favorites[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PokemonDetailScreen(pokemon: pokemon),
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
                  }),
              ),
            );
          },
        );
      },
    );
  }
}
