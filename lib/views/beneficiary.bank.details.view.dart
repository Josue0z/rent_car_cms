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
                      Expanded(
                          child: Text('Banco',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: kLabelsFontColor,
                                      fontWeight: kLabelsFontWeight))),
                      Obx(() => Expanded(
                          child: Text(
                              controller.usuario.value?.beneficiario?.banco
                                      ?.bancoNombre ??
                                  '',
                              textAlign: TextAlign.right)))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Tipo de cuenta',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(
                              controller.usuario.value?.beneficiario
                                      ?.bancoCuentaTipo?.name ??
                                  '',
                              textAlign: TextAlign.right)))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Numero de cuenta',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(
                              controller.usuario.value?.beneficiario
                                      ?.beneficiarioCuentaNo ??
                                  '',
                              textAlign: TextAlign.right)))
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
