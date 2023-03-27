import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zona_hub/src/services/reverse_geocode_service.dart';
import 'package:zona_hub/src/views/post/select_location.dart';

final List<String> _chips = [
  'Animales',
  'Ayuda',
  'Aviso',
  'Salud',
  'Social',
];
final List<String> _selectedChips = [];
File? _currentImageFile;

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
  LatLng? _currentLatLng;
  AddressDetail? addressDetail;
  bool _errorOnChips = false;
  bool _errorOnDates = false;
  bool _warningOnAddress = false;

  @override
  void initState() {
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
            DateTime.now().subtract(const Duration(days: 5)), //DateTime.now()
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

  Future<LatLng?> _goToSelectLocationPage() async {
    final LatLng? locationOnMap = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SelectLocationWidget()));
    return locationOnMap;
  }

  void _getAddress(LatLng location) async {
    addressDetail = await getHumanReadableAddress(location);
    if (addressDetail != null) {
      setState(() {
        if (addressDetail!.address.isNotEmpty) {
          _addressController.text = addressDetail!.address;
        } else {
          _addressController.text = addressDetail!.city;
        }
      });
    }
  }

  void _submit() async {
    debugPrint('Formulario válido');
    debugPrint("Title: ${_titleController.text}");
    debugPrint("Desc: ${_descriptionController.text}");
    debugPrint("Address : ${_addressController.text}");
    debugPrint("Address geohash: ${null}");
    debugPrint("Address geopoint: ${_currentLatLng.toString()}");
    debugPrint(
        "Begin Date: ${_endDateController.text.isEmpty ? null : _beginDateController.text}");
    debugPrint(
        "End Date: ${_endDateController.text.isEmpty ? _beginDateController.text : _endDateController.text}");
    debugPrint(_selectedChips.toString());
    debugPrint("Imagen  ${_currentImageFile?.path}");
  }

  void getGeopointFromAddress() {}

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
                maxLength: 50,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title),
                    labelText: 'Título',
                    hintText: "Resumen del tema",
                    suffixIcon: IconButton(
                        onPressed: () => _titleController.clear(),
                        icon: const Icon(Icons.clear))),
                validator: _validateTextField,
              ),
              TextFormField(
                maxLength: 200,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _descriptionController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.edit),
                    labelText: 'Descripción',
                    hintText: "Detalles sobre el tema"),
                validator: _validateTextField,
              ),
              Hero(
                tag: "address",
                child: Material(
                  child: TextFormField(
                    controller: _addressController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_pin),
                      labelText: 'Dirección',
                    ),
                    readOnly: true,
                    validator: _validateTextField,
                    onTap: () async {
                      LatLng? value = await _goToSelectLocationPage();
                      debugPrint("LatLng obtenido: $value");
                      if (value != null) {
                        _currentLatLng = value;
                        _getAddress(_currentLatLng!);
                      }
                    },
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
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: TextFormField(
                        controller: _beginDateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.calendar_today_rounded, size: 16),
                          labelText: 'Inicio',
                        ),
                        validator: _validateTextField,
                        readOnly: true,
                        onTap: () => _datePickerOnTap(_beginDateController)),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 10,
                    child: Visibility(
                      visible: _manyDays,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _endDateController,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.calendar_today_rounded, size: 16),
                          labelText: 'Fin',
                        ),
                        validator: _validateEndDateField,
                        readOnly: true,
                        onTap: () => _datePickerOnTap(_endDateController),
                      ),
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
              const ImagePostWidget(),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _errorOnChips = _selectedChips.isEmpty;
                        _errorOnDates = !_areDatesCoherent();
                      });
                      if (!_errorOnChips && !_errorOnDates) {
                        _submit();
                      }
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

class ImagePostWidget extends StatefulWidget {
  const ImagePostWidget({super.key});

  @override
  State<ImagePostWidget> createState() => _ImagePostWidgetState();
}

class _ImagePostWidgetState extends State<ImagePostWidget> {
  final StreamController<File?> _imageStreamController =
      StreamController.broadcast();

  void _pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: source);
    if (xFile != null) {
      _currentImageFile = File(xFile.path);
      _imageStreamController.add(_currentImageFile);
    }
  }

  void _deleteImage() {
    _currentImageFile = null;
    _imageStreamController.add(_currentImageFile);
  }

  @override
  void dispose() {
    _imageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Imagen"),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, size: 14),
                  label: const Text("Cámara", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.image, size: 14),
                  label: const Text("Galería", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
        StreamBuilder(
          stream: _imageStreamController.stream,
          initialData: null,
          builder: (context, AsyncSnapshot<File?> snapshot) {
            return SizedBox(
                width: double.infinity,
                child: snapshot.hasData
                    ? Image.file(snapshot.data!)
                    : Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: const Padding(
                            padding: EdgeInsets.all(30),
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 30,
                            )),
                      ));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: _deleteImage,
              icon:
                  const Icon(Icons.delete_sharp, size: 14, color: Colors.white),
              label: const Text("Eliminar",
                  style: TextStyle(fontSize: 14, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
