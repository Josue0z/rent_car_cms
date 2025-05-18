// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/settings.dart';

class ColorsEditorPage extends StatefulWidget {
  final MyColor? autoColor;
  bool editing;
  ColorsEditorPage({super.key, this.autoColor, this.editing = false});

  @override
  State<ColorsEditorPage> createState() => _ColorsEditorPageState();
}

class _ColorsEditorPageState extends State<ColorsEditorPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController autoColor = TextEditingController();

  Color currentColor = Colors.transparent;

  String get title {
    return widget.editing ? 'EDITANDO COLOR...' : 'CREANDO COLOR...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR COLOR' : 'CREAR COLOR';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xautoColor = MyColor(
            colorId: widget.autoColor?.colorId,
            colorNombre: autoColor.text,
            colorHexadecimal: ColorToHex(currentColor).toHexString());
        if (widget.editing) {
          await xautoColor.update();
        } else {
          await xautoColor.create();
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
    currentColor = widget.autoColor != null
        ? HexColor(widget.autoColor?.colorHexadecimal ?? '')
        : Colors.transparent;

    autoColor.value =
        TextEditingValue(text: widget.autoColor?.colorNombre ?? '');
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
                ColorPicker(
                    pickerColor: widget.autoColor != null
                        ? HexColor(widget.autoColor?.colorHexadecimal ?? '')
                        : Colors.transparent,
                    onColorChanged: (color) {
                      currentColor = color;
                    }),
                TextFormField(
                  controller: autoColor,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'NOMBRE', labelText: 'COLOR'),
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
