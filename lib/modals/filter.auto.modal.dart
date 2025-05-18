import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';

class FilterAutoModalWidget extends StatefulWidget {
  int currentMarcaId;
  int currentModeloId;
  int currentModeloVersionId;
  int currentEstado;

  FilterAutoModalWidget(
      {super.key,
      this.currentMarcaId = 0,
      this.currentModeloId = 0,
      this.currentModeloVersionId = 0,
      this.currentEstado = 1});

  @override
  State<FilterAutoModalWidget> createState() => _FilterAutoModalWidgetState();
}

class _FilterAutoModalWidgetState extends State<FilterAutoModalWidget> {
  List<Map<String, dynamic>> estados = [
    {'value': 1, 'name': 'Disponible'},
    {'value': 2, 'name': 'No disponible'},
    {'value': 3, 'name': 'En Revision'}
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: 300,
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('Filtros',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  DropdownButtonFormField<int>(
                      value: widget.currentEstado,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: [
                        const DropdownMenuItem(value: 0, child: Text('Todos')),
                        ...List.generate(estados.length, (index) {
                          var estado = estados[index];
                          return DropdownMenuItem(
                              value: estado['value'],
                              child: Text(estado['name']));
                        }),
                      ],
                      onChanged: (id) {
                        widget.currentEstado = id ?? 0;
                      }),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  DropdownButtonFormField(
                      value: widget.currentMarcaId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Marca'),
                      items: [
                        const DropdownMenuItem(value: 0, child: Text('Todos')),
                        ...List.generate(marcas.length, (index) {
                          var marca = marcas[index];
                          return DropdownMenuItem(
                              value: marca.marcaId,
                              child: Text(marca.marcaNombre ?? ''));
                        }),
                      ],
                      onChanged: (id) async {
                        if (widget.currentMarcaId != id) {
                          setState(() {
                            widget.currentModeloVersionId = 0;
                            modelosVersiones = [];
                          });
                        }
                        widget.currentMarcaId = id ?? 0;

                        setState(() {
                          widget.currentModeloId = 0;
                          modelos = [];
                        });

                        modelos =
                            await Modelo.get(marcaId: widget.currentMarcaId);

                        setState(() {});
                      }),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  DropdownButtonFormField(
                      value: widget.currentModeloId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Modelo'),
                      items: [
                        const DropdownMenuItem(value: 0, child: Text('Todos')),
                        ...List.generate(modelos.length, (index) {
                          var modelo = modelos[index];
                          return DropdownMenuItem(
                              value: modelo.modeloId,
                              child: Text(modelo.modeloNombre ?? ''));
                        }),
                      ],
                      onChanged: (id) async {
                        if (widget.currentModeloId != id) {
                          setState(() {
                            widget.currentModeloVersionId = 0;
                            modelosVersiones = [];
                          });
                        }
                        widget.currentModeloId = id ?? 0;

                        modelosVersiones = await ModeloVersion.get(
                            modeloId: widget.currentModeloId);

                        setState(() {});
                      }),
                  const SizedBox(height: kDefaultPadding),
                  DropdownButtonFormField(
                      value: widget.currentModeloVersionId,
                      isExpanded: true,
                      decoration:
                          const InputDecoration(labelText: 'Modelo Version'),
                      items: [
                        const DropdownMenuItem(value: 0, child: Text('Todos')),
                        ...List.generate(modelosVersiones.length, (index) {
                          var modelo = modelosVersiones[index];
                          return DropdownMenuItem(
                              value: modelo.versionId,
                              child: Text(modelo.versionNombre ?? ''));
                        }),
                      ],
                      onChanged: (id) {
                        setState(() {
                          widget.currentModeloVersionId = id ?? 0;
                        });
                      }),
                  const SizedBox(height: kDefaultPadding),
                  AppCustomButton(
                    onPressed: () {
                      Get.back(result: {
                        'marcaId': widget.currentMarcaId,
                        'modeloId': widget.currentModeloId,
                        'modeloVersionId': widget.currentModeloVersionId,
                        'estado': widget.currentEstado
                      });
                    },
                    children: const [Text('Filtrar')],
                  )
                ],
              ))),
    );
  }
}
