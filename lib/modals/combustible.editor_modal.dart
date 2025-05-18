// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/settings.dart';

class CombustiblesEditorModal extends StatefulWidget {
  final Combustible? combustible;
  bool editing;
  CombustiblesEditorModal({super.key, this.combustible, this.editing = false});

  @override
  State<CombustiblesEditorModal> createState() =>
      _CombustiblesEditorModalState();
}

class _CombustiblesEditorModalState extends State<CombustiblesEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController combustible = TextEditingController();

  String get title {
    return widget.editing
        ? 'EDITANDO COMBUSTIBLE...'
        : 'CREANDO COMBUSTIBLE...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR COMBUSTIBLE' : 'CREAR COMBUSTIBLE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xcombustible = Combustible(
          combustibleId: widget.combustible?.combustibleId,
          combustibleNombre: combustible.text,
        );

        if (widget.editing) {
          await xcombustible.update();
        } else {
          await xcombustible.create();
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

  @override
  void initState() {
    combustible.value =
        TextEditingValue(text: widget.combustible?.combustibleNombre ?? '');

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
                TextFormField(
                  controller: combustible,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      hintText: 'NOMBRE', labelText: 'COMBUSTIBLE'),
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
