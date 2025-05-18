// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/settings.dart';

class CitysEditorModal extends StatefulWidget {
  final Ciudad? city;
  final Provincia? province;
  bool editing;
  CitysEditorModal({super.key, this.city, this.province, this.editing = false});

  @override
  State<CitysEditorModal> createState() => _CitysEditorModalState();
}

class _CitysEditorModalState extends State<CitysEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController city = TextEditingController();

  String get title {
    return widget.editing ? 'EDITANDO CIUDAD...' : 'CREANDO CIUDAD...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR CIUDAD' : 'CREAR CIUDAD';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xcity = Ciudad(
            ciudadId: widget.city?.ciudadId,
            ciudadNombre: city.text,
            provinciaId: widget.province?.provinciaId,
            paisId: 214);

        if (widget.editing) {
          await xcity.update();
        } else {
          await xcity.create();
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
    city.value = TextEditingValue(text: widget.city?.ciudadNombre ?? '');
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
                  controller: city,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'NOMBRE', labelText: 'CIUDAD'),
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
