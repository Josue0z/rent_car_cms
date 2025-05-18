import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/banco.cuenta.tipo.dart';
import 'package:rent_car_cms/models/banco.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class BankAccountEditorModal extends StatefulWidget {
  const BankAccountEditorModal({super.key});

  @override
  State<BankAccountEditorModal> createState() => _BankAccountEditorModalState();
}

class _BankAccountEditorModalState extends State<BankAccountEditorModal> {
  TextEditingController bancoNum = TextEditingController();
  int currentBancoId = 0;
  int currentBancoCuentaTipo = 0;

  final UIController _uiController = Get.find<UIController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        _uiController.usuario.value?.beneficiario?.bancoId = currentBancoId;
        _uiController.usuario.value?.beneficiario?.beneficiarioCuentaTipo =
            currentBancoCuentaTipo;

        _uiController.usuario.value?.beneficiario?.beneficiarioCuentaNo =
            bancoNum.text;
        showLoader(context);

        await _uiController.usuario.value?.beneficiario?.update();

        _uiController.usuario.refresh();

        Navigator.pop(context);
        Navigator.pop(context);

        showSnackBar(context, 'Tu datos fueron cambiados');
      } catch (e) {
        Navigator.pop(context);
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    bancoNum.value = TextEditingValue(
        text: _uiController.usuario.value?.beneficiario?.beneficiarioCuentaNo ??
            '');
    currentBancoId =
        _uiController.usuario.value?.beneficiario?.banco?.bancoId ?? 0;
    currentBancoCuentaTipo = _uiController
            .usuario.value?.beneficiario?.bancoCuentaTipo?.bancoCuentaTipoId ??
        0;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Editando datos bancarios...',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                          value: currentBancoId,
                          validator: (val) =>
                              val == 0 ? 'CAMPO OBLIGATORIO' : null,
                          items: [
                            Banco(bancoId: 0, bancoNombre: 'BANCO'),
                            ...bancos
                          ].map((e) {
                            return DropdownMenuItem(
                                value: e.bancoId, child: Text(e.bancoNombre!));
                          }).toList(),
                          onChanged: (id) {
                            currentBancoId = id ?? 0;
                          }),
                      const SizedBox(height: kDefaultPadding),
                      DropdownButtonFormField(
                          value: currentBancoCuentaTipo,
                          validator: (val) =>
                              val == 0 ? 'CAMPO OBLIGATORIO' : null,
                          items: [
                            BancoCuentaTipo(
                                bancoCuentaTipoId: 0, name: 'TIPO DE CUENTA'),
                            ...bancosCuentaTipo
                          ].map((e) {
                            return DropdownMenuItem(
                                value: e.bancoCuentaTipoId,
                                child: Text(e.name!));
                          }).toList(),
                          onChanged: (id) {
                            currentBancoCuentaTipo = id ?? 0;
                          }),
                      const SizedBox(height: kDefaultPadding),
                      TextFormField(
                        controller: bancoNum,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => _onSubmit(),
                        validator: (val) =>
                            val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                        decoration: const InputDecoration(
                            labelText: 'NUMERO DE CUENTA',
                            hintText: '0000000000'),
                      ),
                      const SizedBox(height: kDefaultPadding),
                      AppCustomButton(
                          onPressed: _onSubmit,
                          children: const [Text('EDITAR DATOS')])
                    ],
                  )))),
    );
  }
}
