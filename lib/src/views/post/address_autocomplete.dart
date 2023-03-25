import 'package:flutter/material.dart';

class AddressAutocompletePage extends StatefulWidget {
  const AddressAutocompletePage({super.key});

  @override
  State<AddressAutocompletePage> createState() =>
      _AddressAutocompletePageState();
}

class _AddressAutocompletePageState extends State<AddressAutocompletePage> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Hero(
                        tag: "address",
                        child: Material(
                          child: TextFormField(
                            controller: _addressController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.location_pin),
                              labelText: 'Dirección',
                            ),
                            validator: _validateTextField,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Address confirmado");
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.check),
                        ))
                  ],
                ),
              ),
              Center(
                child: Text("Lista No implementada"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
