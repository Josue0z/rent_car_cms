import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/modals/bank.account.editor.modal.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class BeneficiaryBankDetailsView extends StatefulWidget {
  final String titleView;

  const BeneficiaryBankDetailsView({super.key, required this.titleView});

  @override
  State<BeneficiaryBankDetailsView> createState() =>
      _BeneficiaryBankDetailsViewState();
}

class _BeneficiaryBankDetailsViewState
    extends State<BeneficiaryBankDetailsView> {
  final UIController controller = Get.find<UIController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Datos Bancarios',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Banco')),
                      Obx(() => Text(controller.usuario.value?.beneficiario
                              ?.banco?.bancoNombre ??
                          ''))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(child: Text('Tipo de cuenta')),
                      Obx(() => Text(controller.usuario.value?.beneficiario
                              ?.bancoCuentaTipo?.name ??
                          ''))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(child: Text('Numero de cuenta')),
                      Obx(() => Text(controller.usuario.value?.beneficiario
                              ?.beneficiarioCuentaNo ??
                          ''))
                    ],
                  ),
                  const Divider(),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const BankAccountEditorModal());
        },
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
