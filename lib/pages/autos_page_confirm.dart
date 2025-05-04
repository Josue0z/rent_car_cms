import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/settings.dart';

class AutosPageConfirm extends StatefulWidget {
  final Auto auto;
  const AutosPageConfirm({super.key, required this.auto});

  @override
  State<AutosPageConfirm> createState() => _AutosPageConfirmState();
}

class _AutosPageConfirmState extends State<AutosPageConfirm> {
  _onSelected(ImagenModel imagen, int id) {}
  Widget _buildCard(ImagenModel imagen) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black12),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(imagen.urlImagen, fit: BoxFit.cover)),
          Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: imagen.color),
                child: Text(
                  imagen.imagenEstatusLabel,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: kLabelsFontWeight),
                ),
              )),
          Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: PopupMenuButton(
                    onSelected: (id) => _onSelected(imagen, id),
                    itemBuilder: (ctx) {
                      return const [
                        PopupMenuItem(value: 1, child: Text('Aceptar Imagen')),
                        PopupMenuItem(value: 2, child: Text('Rechazar Imagen'))
                      ];
                    }),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.auto.marca?.marcaNombre} ${widget.auto.modelo?.modeloNombre} ${widget.auto.autoAno}'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  ...List.generate(widget.auto.imagenesColeccion?.length ?? 0,
                      (index) {
                    var imagen = widget.auto.imagenesColeccion![index];
                    return _buildCard(imagen);
                  })
                ],
              ))),
    );
  }
}
