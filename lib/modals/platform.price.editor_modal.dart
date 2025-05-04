// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/precio.dart';
import 'package:rent_car_cms/settings.dart';

class PlatformPriceEditorModal extends StatefulWidget {
  final Precio? platformPrice;
  bool editing;
  PlatformPriceEditorModal(
      {super.key, this.platformPrice, this.editing = false});

  @override
  State<PlatformPriceEditorModal> createState() =>
      _PlatformPriceEditorModalState();
}

class _PlatformPriceEditorModalState extends State<PlatformPriceEditorModal> {
  final formKey = GlobalKey<FormState>();
  TextEditingController platformPriceName = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController beneficiaryPrice = TextEditingController();
  TextEditingController clientPrice = TextEditingController();

  String get title {
    return widget.editing ? 'EDITING PRICE...' : 'CREATING PRICE...';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE PRICE' : 'CREATE PRICE';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xprice = Precio(
          precioId: widget.platformPrice?.precioId,
          precioNombre: platformPriceName.text,
          precioCliente:
              double.tryParse(clientPrice.text.replaceAll(',', '')) ?? 0,
          precioBeneficiario:
              double.tryParse(beneficiaryPrice.text.replaceAll(',', '')) ?? 0,
        );

        if (widget.editing) {
          await xprice.update();
        } else {
          await xprice.create();
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
    platformPriceName.value =
        TextEditingValue(text: widget.platformPrice?.precioNombre ?? '');
    clientPrice.value = TextEditingValue(
        text: widget.platformPrice?.precioCliente.toString() ?? '');

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
                  controller: platformPriceName,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  decoration: const InputDecoration(
                      hintText: 'NAME', labelText: 'PLATFORM PRICE'),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextFormField(
                  controller: clientPrice,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  validator: (val) => val!.isEmpty ? 'FIELD REQUIRED' : null,
                  decoration: const InputDecoration(
                      hintText: 'VALUE', labelText: 'CLIENT PRICE'),
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
