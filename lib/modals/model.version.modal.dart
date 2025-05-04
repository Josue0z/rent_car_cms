// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/settings.dart';

class ModelVersionEditorModal extends StatefulWidget {
  final ModeloVersion? modeloVersion;
  List<Modelo> modelos;

  bool editing;
  ModelVersionEditorModal(
      {super.key,
      this.editing = false,
      this.modeloVersion,
      this.modelos = const []});

  @override
  State<ModelVersionEditorModal> createState() =>
      _ModelVersionEditorModalState();
}

class _ModelVersionEditorModalState extends State<ModelVersionEditorModal> {
  final formKey = GlobalKey<FormState>();

  TextEditingController modeloVersion = TextEditingController();

  int currentModelId = 0;

  String get title {
    return widget.editing ? 'EDITING VERSION...' : 'CREATING VERSION...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE VERSION' : 'CREATE VERSION';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xmodelVersion = ModeloVersion(
            versionId: widget.modeloVersion?.versionId,
            modeloId: widget.modeloVersion?.modeloId,
            versionNombre: modeloVersion.text);
        if (widget.editing) {
          await xmodelVersion.update();
        } else {
          await xmodelVersion.create();
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
    currentModelId = widget.modeloVersion?.modeloId ?? 0;
    modeloVersion.value =
        TextEditingValue(text: widget.modeloVersion?.versionNombre ?? '');
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
                        labelText: 'MAKE', enabled: false),
                    validator: (val) => val == 0 ? 'FIELD REQURIED' : null,
                    value: currentModelId,
                    items: [
                      Modelo(modeloId: 0, modeloNombre: 'MODEL'),
                      ...widget.modelos
                    ]
                        .map((e) => DropdownMenuItem(
                            enabled: false,
                            value: e.modeloId,
                            child: Text(e.modeloNombre!)))
                        .toList(),
                    onChanged: null),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
                TextFormField(
                  controller: modeloVersion,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'MODEL', labelText: 'MODEL'),
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
