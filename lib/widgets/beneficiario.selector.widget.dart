import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class BeneficiarioSelector extends FormField<Beneficiario?> {
  BeneficiarioSelector(
      {super.key,
      FormFieldSetter<Beneficiario?>? onChanged,
      FormFieldValidator<Beneficiario?>? validator,
      Beneficiario? initialValue})
      : super(
            initialValue: initialValue,
            validator: validator,
            onSaved: onChanged,
            builder: (state) {
              var value = initialValue ?? state.value;
              void openSearchModal() async {
                var selectedBeneficiario = await Get.to<Beneficiario?>(
                    () => const BeneficiarioSearchScreen());

                if (selectedBeneficiario != null) {
                  state.didChange(selectedBeneficiario);
                  state.save();
                  state.validate();
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: openSearchModal,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 0.8,
                          horizontal: kDefaultPadding / 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kPlaceholdersFontColor)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(value?.beneficiarioNombre ??
                                  "Seleccionar Beneficiario")),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                  state.hasError
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: Text(
                            state.errorText ?? '',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            });
}

class BeneficiarioSearchScreen extends StatefulWidget {
  const BeneficiarioSearchScreen({super.key});

  @override
  BeneficiarioSearchScreenState createState() =>
      BeneficiarioSearchScreenState();
}

class BeneficiarioSearchScreenState extends State<BeneficiarioSearchScreen> {
  List<Beneficiario> _beneficiarios = [];
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: "Buscar Beneficiarios",
        actions: const [SizedBox(width: kDefaultPadding * 3)],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: "Buscar",
                      hintText: 'Nombre, Rnc...',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) async {
                    _searchQuery = value;
                    _beneficiarios =
                        await Beneficiario.get(search: _searchQuery);
                    setState(() {});
                  },
                ))),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _beneficiarios
                  .map((b) => ListTile(
                        title: Text(b.beneficiarioNombre ?? ''),
                        onTap: () {
                          Get.back(result: b);
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
