import 'package:flutter/material.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final List<String> _chipNames = [
    "Aviso",
    "Ayuda",
    "Evento",
    "Salud",
    "Animales"
  ];
  final List<String> _selectedChips = [];

  void _onChipSelected(String name) {
    setState(() {
      if (_selectedChips.contains(name)) {
        _selectedChips.remove(name);
      } else {
        _selectedChips.add(name);
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: 'Campo 1',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: 'Campo 2',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(
                labelText: 'Campo 3',
              ),
            ),
            SizedBox(height: 16),
            Text('Selecciona algunos nombres:'),
            Wrap(
              spacing: 8,
              children: _chipNames.map((name) {
                return FilterChip(
                  label: Text(name),
                  selected: _selectedChips.contains(name),
                  onSelected: (selected) => _onChipSelected(name),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción a realizar cuando se presione el botón
                print('Campo 1: ${_controller1.text}');
                print('Campo 2: ${_controller2.text}');
                print('Campo 3: ${_controller3.text}');
                print('Chips seleccionados: $_selectedChips');
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
