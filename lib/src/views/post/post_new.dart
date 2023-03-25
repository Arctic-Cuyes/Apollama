import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:zona_hub/src/views/post/address_autocomplete.dart';

final List<String> _chips = [
  'Animales',
  'Ayuda',
  'Aviso',
  'Salud',
  'Social',
];
final List<String> _selectedChips = [];

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _beginDateController = TextEditingController();
  final _endDateController = TextEditingController();
  bool _manyDays = false;
  Map _fakeLocation = {
    "geohash": "6nxcc",
    "geopoint": const LatLng(-8.108805, -79.028402),
  };

  @override
  void initState() {
    _addressController.text = "Ejemplo";
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _beginDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  bool _errorOnChips = false;
  bool _errorOnDates = false;

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validateEndDateField(String? value) {
    if (_manyDays && (value == null || value.isEmpty)) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  bool _areDatesCoherent() {
    late DateTime begin;
    late DateTime end;
    if (_manyDays) {
      begin = DateFormat('dd/MM/yyyy').parse(_beginDateController.text);
      end = DateFormat('dd/MM/yyyy').parse(_endDateController.text);
      return end.isAfter(begin) || end.isAtSameMomentAs(begin);
    } else {
      return true;
    }
  }

  void _datePickerOnTap(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        context: context,
        initialDate: DateTime.now(),
        firstDate:
            DateTime.now().subtract(const Duration(days: 7)), //DateTime.now()
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

      setState(() {
        controller.text = formattedDate;
      });
    } else {
      debugPrint("Date is not selected");
    }
  }

  void _goToAddressAutoCompletePage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddressAutocompletePage()));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Se construye formulario");
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Publicación")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 40,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    labelText: 'Título',
                    hintText: "Resumen del tema"),
                validator: _validateTextField,
              ),
              TextFormField(
                maxLength: 100,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _descriptionController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: 'Descripción',
                    hintText: "Detalles sobre el tema"),
                validator: _validateTextField,
              ),
              Hero(
                tag: "address",
                child: Material(
                  child: TextFormField(
                    controller: _addressController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.location_pin),
                      labelText: 'Dirección',
                    ),
                    readOnly: !true,
                    validator: _validateTextField,
                    onTap: () => _goToAddressAutoCompletePage(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Fechas"),
                  Row(
                    children: [
                      Checkbox(
                        fillColor: const MaterialStatePropertyAll(Colors.amber),
                        value: _manyDays,
                        onChanged: (value) {
                          setState(() {
                            _manyDays = value!;
                            _endDateController.text = "";
                          });
                        },
                      ),
                      const Text("Varios días")
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  TextFormField(
                      controller: _beginDateController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today_rounded, size: 16),
                        labelText: 'Inicio',
                      ),
                      validator: _validateTextField,
                      readOnly: true,
                      onTap: () => _datePickerOnTap(_beginDateController)),
                  // const Spacer(
                  //   flex: 1,
                  // ),
                  Visibility(
                    visible: _manyDays,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today_rounded, size: 16),
                        labelText: 'Fin',
                      ),
                      validator: _validateEndDateField,
                      readOnly: true,
                      onTap: () => _datePickerOnTap(_endDateController),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _errorOnDates,
                child: const Text(
                  'La fecha de fin debe ser mayor a la fecha de inicio',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.tag),
                  Text('Categorias'),
                ],
              ),
              const TagChipsWidget(),
              Visibility(
                visible: _errorOnChips,
                child: const Text(
                  'Debe seleccionar al menos una categoría',
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
                      _errorOnChips = _selectedChips.isEmpty;
                      _errorOnDates = !_areDatesCoherent();
                    });
                    if (_formKey.currentState!.validate() &&
                        !_errorOnChips &&
                        !_errorOnDates) {
                      debugPrint(_selectedChips.toString());
                      debugPrint('Formulario válido');
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagChipsWidget extends StatefulWidget {
  const TagChipsWidget({super.key});

  @override
  State<TagChipsWidget> createState() => _TagChipsWidgetState();
}

class _TagChipsWidgetState extends State<TagChipsWidget> {
  void _handleChipSelected(String value) {
    setState(() {
      if (_selectedChips.contains(value)) {
        _selectedChips.remove(value);
      } else {
        _selectedChips.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Se construye chips");
    return Wrap(
      children: _chips.map((chip) {
        final isSelected = _selectedChips.contains(chip);
        final index = _selectedChips.indexOf(chip);
        final color = isSelected
            ? index == 0
                ? Colors.lightGreen.shade900
                : Colors.lightGreen.shade500
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
    );
  }
}
