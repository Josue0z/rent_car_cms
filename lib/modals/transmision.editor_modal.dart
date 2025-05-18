// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/settings.dart';

class TransmisionesEditorModal extends StatefulWidget {
  final Transmision? transmision;
  bool editing;
  TransmisionesEditorModal({super.key, this.transmision, this.editing = false});

  @override
  State<TransmisionesEditorModal> createState() =>
      _TransmisionesEditorModalState();
}

class _TransmisionesEditorModalState extends State<TransmisionesEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController transmision = TextEditingController();

  String get title {
    return widget.editing
        ? 'EDITANDO TRANSMISION...'
        : 'CREANDO TRANSMISION...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR TRANSMISION' : 'CREAR TRANSMISION';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xtransmision = Transmision(
          transmisionId: widget.transmision?.transmisionId,
          transmisionNombre: transmision.text,
        );

        if (widget.editing) {
          await xtransmision.update();
        } else {
          await xtransmision.create();
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
    transmision.value =
        TextEditingValue(text: widget.transmision?.transmisionNombre ?? '');

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
                  controller: transmision,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      hintText: 'NOMBRE', labelText: 'TRANSMISION'),
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
