// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/settings.dart';

class CarTypesEditorModal extends StatefulWidget {
  final TipoAuto? autoType;
  bool editing;
  CarTypesEditorModal({super.key, this.autoType, this.editing = false});

  @override
  State<CarTypesEditorModal> createState() => _CarTypesEditorModalState();
}

class _CarTypesEditorModalState extends State<CarTypesEditorModal> {
  final formKey = GlobalKey<FormState>();

  TextEditingController province = TextEditingController();

  String get title {
    return widget.editing ? 'EDITING CAR TYPE...' : 'CREATING CAR TYPE...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE CAR TYPE' : 'CREATE CAR TYPE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xautotype = TipoAuto(
            tipoId: widget.autoType?.tipoId, tipoNombre: province.text);
        if (widget.editing) {
          await xautotype.update();
        } else {
          await xautotype.create();
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
    province.value = TextEditingValue(text: widget.autoType?.tipoNombre ?? '');
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
                  controller: province,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'NAME', labelText: 'CAR TYPE'),
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
