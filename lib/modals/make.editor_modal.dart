// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/circle.image.selector.widget.dart';

class MakeEditorModal extends StatefulWidget {
  final Marca? make;
  bool editing;

  MakeEditorModal({super.key, this.editing = false, this.make});

  @override
  State<MakeEditorModal> createState() => _MakeEditorModalState();
}

class _MakeEditorModalState extends State<MakeEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController make = TextEditingController();
  Uint8List? imagen;
  String? imagenBase64;

  String get title {
    return widget.editing ? 'EDITING MAKE...' : 'CREATING MAKE...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE MAKE' : 'CREATE MAKE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xmake = Marca(
            marcaId: widget.make?.marcaId,
            marcaNombre: make.text,
            marcaLogo: imagenBase64);
        if (widget.editing) {
          await xmake.update();
        } else {
          await xmake.create();
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
    if (widget.make != null) {
      imagen = base64Decode(widget.make?.marcaLogo ?? '');
      imagenBase64 = widget.make?.marcaLogo;
    }
    make.value = TextEditingValue(text: widget.make?.marcaNombre ?? '');
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
                          fontSize: kDefaultFontSized,
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
                const SizedBox(height: kDefaultPadding),
                CircleImageSelectorWidget(
                    imagen: imagen,
                    onChanged: (ximagen, xbase64) {
                      imagen = ximagen;
                      imagenBase64 = xbase64;
                    }),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: make,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'MAKE', labelText: 'MAKE'),
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
