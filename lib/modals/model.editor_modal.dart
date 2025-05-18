// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/settings.dart';

class ModelEditorModal extends StatefulWidget {
  final Modelo? model;
  List<Marca> marcas;

  bool editing;
  ModelEditorModal(
      {super.key, this.editing = false, this.model, this.marcas = const []});

  @override
  State<ModelEditorModal> createState() => _ModelEditorModalState();
}

class _ModelEditorModalState extends State<ModelEditorModal> {
  final formKey = GlobalKey<FormState>();

  TextEditingController model = TextEditingController();

  int currentMakeId = 0;

  String get title {
    return widget.editing ? 'EDITANDO MODELO...' : 'CREANDO MODELO...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR MODELO' : 'CREAR MODELO';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xmodel = Modelo(
            modeloId: widget.model?.modeloId,
            marcaId: currentMakeId,
            modeloNombre: model.text);
        if (widget.editing) {
          await xmodel.update();
        } else {
          await xmodel.create();
        }
        if (widget.editing) {
          Navigator.pop(context, 'UPDATE');
        } else {
          Navigator.pop(context, 'CREATE');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  initAsync() async {
    try {
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    currentMakeId = widget.model?.marcaId ?? 0;
    print(widget.model);
    model.value = TextEditingValue(text: widget.model?.modeloNombre ?? '');
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Dialog(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
            padding: const EdgeInsets.all(kDefaultPadding),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: kDefaultFontSize,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                DropdownButtonFormField(
                    decoration: const InputDecoration(
                        labelText: 'MARCA', enabled: false),
                    validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                    value: currentMakeId,
                    items: [
                      Marca(marcaId: 0, marcaNombre: 'MARCA'),
                      ...widget.marcas
                    ]
                        .map((e) => DropdownMenuItem(
                            enabled: false,
                            value: e.marcaId,
                            child: Text(e.marcaNombre!)))
                        .toList(),
                    onChanged: null),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
                TextFormField(
                  controller: model,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'MODELO', labelText: 'MODELO'),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _onSubmit, child: Text(btnTitle)),
                )
              ],
            ),
          ),
        ));
  }
}
