// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/deposito.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/beneficiario.selector.widget.dart';
import 'package:rent_car_cms/widgets/image.selector.widget.dart';

class DepositosEditorModal extends StatefulWidget {
  final Depositos? deposito;
  bool editing;
  DepositosEditorModal({super.key, this.deposito, this.editing = false});

  @override
  State<DepositosEditorModal> createState() => _DepositosEditorModalState();
}

class _DepositosEditorModalState extends State<DepositosEditorModal> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? data;
  String imagenBase64 = '';

  Beneficiario? beneficiario;

  TextEditingController monto = TextEditingController();

  String get title {
    return widget.editing ? 'EDITANDO DEPOSITO...' : 'CREANDO DEPOSITO...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR DEPOSITO' : 'CREAR DEPOSITO';
  }

  _onSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        var xdeposito = Depositos(
          depositoId: widget.deposito?.depositoId,
          beneficiarioId: beneficiario?.beneficiarioId,
          imagenBase64: imagenBase64,
          monto: double.tryParse(monto.text.replaceAll(',', '')),
        );

        if (widget.editing) {
          await xdeposito.update();
        } else {
          await xdeposito.create();
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
    monto.value =
        TextEditingValue(text: widget.deposito?.monto.toString() ?? '');

    if (widget.editing) {
      beneficiario = widget.deposito?.beneficiario;
      imagenBase64 = widget.deposito?.imagenBase64 ?? '';

      data = {'imagenBase64': imagenBase64};
      setState(() {});
    }

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
                ImageSelectorWidget(
                    initialValue: data,
                    validator: (val) =>
                        val == null ? 'La imagen es obligatoria...' : null,
                    onChanged: (xdata) {
                      if (xdata != null) {
                        imagenBase64 = xdata['imagenBase64'];
                        data = xdata;
                        setState(() {});
                      }
                    }),
                const SizedBox(height: kDefaultPadding / 2),
                BeneficiarioSelector(
                  initialValue: beneficiario,
                  validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
                  onChanged: (ben) {
                    beneficiario = ben;
                    setState(() {});
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: monto,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      hintText: '0.00', labelText: 'VALOR'),
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
