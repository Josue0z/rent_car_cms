// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/settings.dart';

class ProvinceEditorModal extends StatefulWidget {
  final Provincia? province;
  bool editing;
  ProvinceEditorModal({super.key, this.editing = false, this.province});

  @override
  State<ProvinceEditorModal> createState() => _ProvinceEditorModalState();
}

class _ProvinceEditorModalState extends State<ProvinceEditorModal> {
  final formKey = GlobalKey<FormState>();

  TextEditingController province = TextEditingController();

  String get title {
    return widget.editing ? 'EDITING PROVINCE...' : 'CREATING PROVINCE...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE PROVINCE' : 'CREATE PROVINCE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xprovince = Provincia(
            provinciaId: widget.province?.provinciaId,
            provinciaNombre: province.text,
            paisId: 214);
        if (widget.editing) {
          await xprovince.update();
        } else {
          await xprovince.create();
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
    province.value =
        TextEditingValue(text: widget.province?.provinciaNombre ?? '');
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
                TextFormField(
                  controller: province,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  onFieldSubmitted: (_) => _onSubmit(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                      hintText: 'NAME', labelText: 'PROVINCE'),
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
