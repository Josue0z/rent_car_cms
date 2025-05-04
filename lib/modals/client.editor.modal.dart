// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/cliente.dart';
import 'package:rent_car_cms/settings.dart';

class ClienteEditorPage extends StatefulWidget {
  Cliente? cliente;

  bool isEditing;

  ClienteEditorPage({super.key, this.cliente, this.isEditing = false});

  @override
  State<ClienteEditorPage> createState() => _ClienteEditorPageState();
}

class _ClienteEditorPageState extends State<ClienteEditorPage> {
  TextEditingController nombre = TextEditingController();

  TextEditingController iden = TextEditingController();

  TextEditingController tel1 = TextEditingController();

  TextEditingController tel2 = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int paisId = 214;

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        if (widget.isEditing) {
          widget.cliente?.clienteNombre = nombre.text;
          widget.cliente?.clienteIdentificacion = iden.text;
          widget.cliente?.clienteTelefono1 = tel1.text;
          widget.cliente?.clienteTelefono2 = tel2.text;
          widget.cliente?.paisId = paisId;
          await widget.cliente?.update();
          Navigator.pop(context, 'UPDATE');
        }
      } catch (e) {
        print(e);
      }
    }
  }
  @override
  void initState() {
    nombre.value = TextEditingValue(text: widget.cliente?.clienteNombre ?? '');
    iden.value = TextEditingValue(text: widget.cliente?.clienteIdentificacion ?? '');
    tel1.value = TextEditingValue(text: widget.cliente?.clienteTelefono1 ?? '');
    tel2.value = TextEditingValue(text: widget.cliente?.clienteTelefono2 ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
          key: formKey,
          child: SizedBox(
              width: 250,
              height: 350,
              child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('CLIENT UPDATING...', style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),)),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                        ],
                      ),
                      
                      Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding/2),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nombre,
                              autofocus: true,
                              validator: (val) =>
                                  val!.isEmpty ? 'NAME REQUIRED' : null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'NAME',
                                  hintText: 'NAME...'),
                            ),
                            const SizedBox(
                              height: kDefaultPadding,
                            ),
                            TextFormField(
                              controller: iden,
                              validator: (val) => val!.isEmpty
                                  ? 'IDENTIFICATION REQUIRED'
                                  : null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'IDENTIFICATION',
                                  hintText: 'IDENTIFICATION...'),
                            ),
                            const SizedBox(
                              height: kDefaultPadding,
                            ),
                            TextFormField(
                              controller: tel1,
                              validator: (val) =>
                                  val!.isEmpty ? 'PHONE 1 REQUIRED' : null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'PHONE 1',
                                  hintText: 'PHONE 1...'),
                            ),
                            const SizedBox(height: kDefaultPadding),
                            TextFormField(
                              controller: tel2,
                              validator: (val) =>
                                  val!.isEmpty ? 'PHONE 2 REQUIRED' : null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'PHONE 2',
                                  hintText: 'PHONE 2...'),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: onSubmit,
                              child: const Text('UPDATE CLIENT')))
                    ],
                  )))),
    );
  }
}
