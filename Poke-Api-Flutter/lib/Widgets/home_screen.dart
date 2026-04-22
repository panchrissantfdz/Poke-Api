import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practicas/Widgets/pokemon_widget.dart';
import 'package:practicas/Widgets/filter_pokemon.dart';
import 'package:practicas/auth/auth_providers.dart';
import 'package:practicas/auth/theme_provider.dart';
import 'package:practicas/Preferences/shared_preferences.dart';
import 'package:practicas/notifications/notification_service.dart';
import '../Widgets/pokemon_favorite.dart';


class HomeScreen extends ConsumerStatefulWidget{
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  bool _isSearching = false;
  String _searchQuery = '';
  List<String> _selectTypePokemon = [];
  bool _notificationsEnabled = false;


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar( //Cambio nuevo: Barra de Búsqueda
        title: !_isSearching ? const Text('Pokédex'):
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'Buscar Pokemon...',
                  border: InputBorder.none,
              ),
            onChanged: (value){
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
            },
            ),
        backgroundColor: colorScheme.error,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.favorite_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Notificaciones',
            icon: Icon(_notificationsEnabled
                ? Icons.notifications_active_rounded
                : Icons.notifications_off_rounded),
            onSelected: (value) async {
              if (value == 'enable') {
                await NotificationService.instance.scheduleEvery30sTesting(minutes: 30);
                if (mounted) {
                  setState(() => _notificationsEnabled = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notificaciones activadas (cada 30s, pruebas)')),
                  );
                }
              } else if (value == 'disable') {
                await NotificationService.instance.cancelAll();
                if (mounted) {
                  setState(() => _notificationsEnabled = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notificaciones desactivadas')),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              if (!_notificationsEnabled)
                const PopupMenuItem(value: 'enable', child: Text('Activar notificaciones'))
              else
                const PopupMenuItem(value: 'disable', child: Text('Desactivar notificaciones')),
            ],
          ),
          PopupMenuButton<AppTheme>(
            tooltip: 'Cambiar tema',
            icon: const Icon(Icons.color_lens_rounded),
            onSelected: (theme) async {
              await ref.read(themeControllerProvider.notifier).setTheme(theme);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: AppTheme.light, child: Text('Tema claro')),
              PopupMenuItem(value: AppTheme.dark, child: Text('Tema oscuro')),
              PopupMenuItem(value: AppTheme.alternate, child: Text('Tema alterno')),
            ],
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(firebaseAuthProvider).signOut();
            },
          ),
          IconButton(

            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if(_isSearching){ //Si no hay dato ingresado
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;

              });
            },


          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final selected = await showModalBottomSheet<List<String>>(
                context: context,
                builder: (context) => const TypeFilterSheet(),
              );

              if (selected != null) {
                setState(() {
                  _selectTypePokemon = selected;
                });
              }
             // print('Tipos seleccionados: $_selectTypePokemon');


            },
          ),
        ],
      ),
      body: PokemonGrid(searchQuery: _searchQuery, selectPokemon: _selectTypePokemon),
    );
  }
}



/*


 */