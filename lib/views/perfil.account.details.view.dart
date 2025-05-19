import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class PerfilAccountDetailsView extends StatefulWidget {
  final String titleView;
  const PerfilAccountDetailsView({super.key, required this.titleView});

  @override
  State<PerfilAccountDetailsView> createState() =>
      _PerfilAccountDetailsViewState();
}

class _PerfilAccountDetailsViewState extends State<PerfilAccountDetailsView> {
  final UIController _uiController = Get.find<UIController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Datos de perfil',
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
                          child: Text(
                        'Razon Social',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(_uiController.usuario.value?.beneficiario
                                  ?.beneficiarioNombre ??
                              '')))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Rnc/Cedula',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(_uiController.usuario.value?.beneficiario
                                  ?.beneficiarioIdentificacion ??
                              '')))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Telefono',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(_uiController.usuario.value?.beneficiario
                                  ?.beneficiarioTelefono ??
                              '')))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Correo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kLabelsFontColor,
                            fontWeight: kLabelsFontWeight),
                      )),
                      Obx(() => Expanded(
                          child: Text(_uiController.usuario.value?.beneficiario
                                  ?.beneficiarioCorreo ??
                              '')))
                    ],
                  ),
                ],
              ))),
    );
  }
}
