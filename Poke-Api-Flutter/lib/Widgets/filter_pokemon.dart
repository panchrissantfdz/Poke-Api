import 'package:flutter/material.dart';

class TypeFilterSheet extends StatefulWidget {
  const TypeFilterSheet({super.key});

  @override
  State<TypeFilterSheet> createState() => _TypeFilterSheetState();
}

class _TypeFilterSheetState extends State<TypeFilterSheet> {
  //Cambiar
  final List<String> _types = [
    'normal', 'fighting', 'flying', 'poison', 'ground', 'rock',
    'water', 'fire', 'steel', 'ghost', 'bug',
    'grass', 'electric', 'psychic', 'ice', 'dragon', 'dark', 'fairy',
    'stellar', 'unknown'
  ];

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Filtrar por tipo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView(
              children: _types.map((type) {
                return CheckboxListTile(
                  title: Text(type[0].toUpperCase() + type.substring(1)),
                  value: _selected.contains(type),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selected.add(type);
                      } else {
                        _selected.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, _selected.toList());
              },
              icon: const Icon(Icons.check),
              label: const Text('Aplicar filtros'),
            ),
          )
        ],

      ),
    );
  }
}
