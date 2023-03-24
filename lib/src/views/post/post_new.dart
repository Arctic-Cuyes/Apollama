import 'dart:math';

import 'package:flutter/material.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final List<String> _chips = [
    'Chip 1',
    'Chip 2',
    'Chip 3',
    'Chip 4',
    'Chip 5',
    'Chip 6'
  ];
  final List<String> _selectedChips = [];

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    super.dispose();
  }

  void _handleChipSelected(String value) {
    setState(() {
      if (_selectedChips.contains(value)) {
        _selectedChips.remove(value);
      } else {
        _selectedChips.add(value);
      }
    });
  }

  bool _showError = false;
  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Publicación")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _textController1,
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                validator: _validateTextField,
              ),
              TextFormField(
                controller: _textController2,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: _validateTextField,
              ),
              TextFormField(
                controller: _textController3,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                ),
                validator: _validateTextField,
              ),
              TextFormField(
                controller: _textController3,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                ),
                validator: _validateTextField,
              ),
              const SizedBox(height: 16.0),
              const Text('Chips'),
              Wrap(
                children: _chips.map((chip) {
                  final isSelected = _selectedChips.contains(chip);
                  final index = _selectedChips.indexOf(chip);
                  final color = isSelected
                      ? index == 0
                          ? Colors.lightGreen.shade800
                          : Colors.lightGreen.shade600
                      : Colors.grey;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(chip),
                      selected: isSelected,
                      selectedColor: color,
                      onSelected: (isSelected) {
                        _handleChipSelected(chip);
                      },
                    ),
                  );
                }).toList(),
              ),
              Visibility(
                visible: _showError,
                child: const Text(
                  'Debe seleccionar al menos un chip',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _showError = _selectedChips.isEmpty;
                    });
                    if (_formKey.currentState!.validate() &&
                        _selectedChips.isNotEmpty) {
                      print('${_selectedChips.toString()}');
                      print('Formulario válido');
                    }
                  },
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
