import 'package:dio/dio.dart';

class PokemonService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'),
  );

  Future<List<Map<String, dynamic>>> getPokemons({required int limit}) async {
    try {
      final response = await _dio.get('pokemon?limit=$limit');
      final results = response.data['results'] as List;

      final pokemons = await Future.wait(results.map((pokemon) async {
        final url = pokemon['url'] as String;
        final idString = url.split('/')[url.split('/').length - 2];
        final formattedId = int.parse(idString).toString().padLeft(3, '0');

        try {
          final detailResponse = await _dio.get('pokemon/$idString');
          final data = detailResponse.data;

          // Tipos
          final typesData = data['types'] as List;
          final types = typesData.map<String>((t) => t['type']['name'] as String).toList();

          // Stats
          final statsData = data['stats'] as List;
          final stats = statsData.map<Map<String, dynamic>>((s) {
            return {
              'name': s['stat']['name'],
              'base_stat': s['base_stat'],
            };
          }).toList();

          // Body
          return {
            'name': pokemon['name'],
            'id': idString,
            'image': 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/$formattedId.png',
            'types': types,
            'stats': stats,
          };
        } catch (e) {
          print('Error al obtener tipos o stats de $idString: $e');
          return {
            'name': pokemon['name'],
            'id': idString,
            'image': 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/$formattedId.png',
            'types': <String>[],
            'stats': <Map<String, dynamic>>[],
          };
        }
      }).toList());

      return pokemons;
    } catch (e) {
      print('Error al obtener pokemons: $e');
      return [];
    }
  }



}