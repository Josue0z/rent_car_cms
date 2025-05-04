import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/address.selector.dart';

class ProfileSettingsPage extends StatefulWidget {
  final String titleView;

  const ProfileSettingsPage({super.key, required this.titleView});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late UIController uiController = Get.find<UIController>();

  late Usuario usuario = uiController.usuario.value!;

  Place? place;
  String address = '';

  onSubmit() async {
    try {
      /* currentBeneficiary.beneficiarioNombre = uiController.name.text;
      currentBeneficiary.beneficiarioIdentificacion = uiController.iden.text;
      currentBeneficiary.beneficiarioDireccion = uiController.address.text;

      if (place != null) {
        currentBeneficiary.beneficiarioCoorX = place?.geometry?.location?.lng;
        currentBeneficiary.beneficiarioCoorY = place?.geometry?.location?.lat;
      }

      await currentBeneficiary.update();
      uiController.currentBeneficiary.value = await Beneficiario.findById(
          currentBeneficiary.beneficiarioId!.toInt());

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('UPDATE BENEFICIARY!')));*/
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    uiController.name.value =
        TextEditingValue(text: usuario.beneficiario?.beneficiarioNombre ?? '');
    uiController.iden.value = TextEditingValue(
        text: usuario.beneficiario?.beneficiarioIdentificacion ?? '');

    uiController.address.value = TextEditingValue(
        text: usuario.beneficiario?.beneficiarioDireccion ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        title: Text(widget.titleView),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            TextFormField(
              controller: uiController.name,
              decoration: const InputDecoration(
                  labelText: 'NAME',
                  hintText: 'NAME',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            TextFormField(
              controller: uiController.iden,
              decoration: const InputDecoration(
                  labelText: 'IDENTIFICATION',
                  hintText: 'IDENTIFICATION',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            AddressSelectorWidget(
                controller: uiController.address,
                onChanged: (xplace) {
                  place = xplace;
                }),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: onSubmit, child: const Text('UPDATE BENEFICIARY')),
            )
          ],
        ),
      ),
    );
  }
}
