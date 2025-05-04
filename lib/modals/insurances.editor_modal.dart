// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/seguro.dart';
import 'package:rent_car_cms/settings.dart';

class InsurancesEditorModal extends StatefulWidget {
  final AutoSeguro? insurance;
  bool editing;
  InsurancesEditorModal({super.key, this.insurance, this.editing = false});

  @override
  State<InsurancesEditorModal> createState() => _InsurancesEditorModalState();
}

class _InsurancesEditorModalState extends State<InsurancesEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController insurance = TextEditingController();
  TextEditingController amount = TextEditingController();

  String get title {
    return widget.editing ? 'EDITING INSURANCE...' : 'CREATING INSURANCE...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE INSURANCE' : 'CREATE INSURANCE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xinsurance = AutoSeguro(
            seguroId: widget.insurance?.seguroId,
            seguroNombre: insurance.text,
            seguroMonto: int.tryParse(amount.text.replaceAll(',', '')) ?? 0,
            seguroEstatus: 1);

        if (widget.editing) {
          await xinsurance.update();
        } else {
          await xinsurance.create();
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
    insurance.value =
        TextEditingValue(text: widget.insurance?.seguroNombre ?? '');
    amount.value =
        TextEditingValue(text: widget.insurance?.seguroMonto?.toString() ?? '');
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
                  controller: insurance,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  decoration: const InputDecoration(
                      hintText: 'NAME', labelText: 'INSURANCE'),
                ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
                TextFormField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  decoration: const InputDecoration(
                      hintText: 'VALUE', labelText: 'AMOUNT'),
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
