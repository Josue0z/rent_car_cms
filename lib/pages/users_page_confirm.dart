import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class UsersPageConfirm extends StatefulWidget {
  final Usuario usuario;
  final List<Usuario> usuarios;

  Future<void> Function() onUpdate;
  UsersPageConfirm(
      {super.key,
      required this.usuario,
      required this.usuarios,
      required this.onUpdate});

  @override
  State<UsersPageConfirm> createState() => _UsersPageConfirmState();
}

class _UsersPageConfirmState extends State<UsersPageConfirm> {
  _onSelected(DocumentoModel doc, int id) async {
    try {
      showLoader(context);
      if (id == 1) {
        await doc.aceptar();
      }

      if (id == 2) {
        await doc.rechazar();
      }

      if (id == 3) {
        var dir = await getTemporaryDirectory();
        File file = File(path.join(dir.path, doc.imagenArchivo));

        if (!file.existsSync()) {
          String base64 = doc.imagenBase64!.split(',')[1];
          var bytes = base64Decode(base64);
          await file.create();
          await file.writeAsBytes(bytes);
        }
        await OpenFile.platform.open(file.path);

        Navigator.pop(context);
      }

      if (id != 3) {
        widget.usuario.documentos =
            await DocumentoModel.get(usuarioId: widget.usuario.usuarioId ?? 0);

        await widget.onUpdate();

        setState(() {});
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(context, e.toString());
    }
  }

  Widget _buildCard(DocumentoModel imagen) {
    Widget widget = const SizedBox();

    Color backgroundColor = Colors.black12;

    Color borderColor = Colors.transparent;

    String label = 'Imagen';

    if (imagen.documentoFormatoId == 1) {
      widget = Positioned.fill(
          child: Image.network(imagen.urlImagen, fit: BoxFit.cover));
    }

    if (imagen.documentoFormatoId == 2) {
      backgroundColor = Colors.white;
      borderColor = Colors.black12;
      label = 'Archivo';
      widget = Positioned.fill(
          child: Center(
        child: Icon(Icons.picture_as_pdf,
            color: Theme.of(context).colorScheme.primary, size: 100),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              color: backgroundColor),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              widget,
              Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: imagen.color),
                    child: Text(
                      imagen.documentoEstatusLabel,
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
                          return [
                            PopupMenuItem(
                                value: 1, child: Text('Aceptar $label')),
                            PopupMenuItem(
                                value: 2, child: Text('Rechazar $label')),
                            PopupMenuItem(value: 3, child: Text('Abrir $label'))
                          ];
                        }),
                  ))
            ],
          ),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10)),
          child: Text(imagen.tipo?.name ?? ''),
        )
      ],
    );
  }

  List<Widget> get contentBenef {
    List<Widget> rows = [];

    if (widget.usuario.usuarioTipo == 2) {
      rows.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text('Banco'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: kLabelsFontWeight))),
              Expanded(
                  child: Text(
                      widget.usuario.beneficiario?.banco?.bancoNombre ??
                          '<None>',
                      textAlign: TextAlign.right))
            ],
          ),
          const Divider()
        ],
      ));

      rows.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                'Banco Numero de Cuenta'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: kLabelsFontWeight),
              )),
              Expanded(
                  child: Text(
                      widget.usuario.beneficiario?.beneficiarioCuentaNo ??
                          '<None>',
                      textAlign: TextAlign.right))
            ],
          ),
          const Divider()
        ],
      ));
      return rows;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title:
            '${widget.usuario.beneficiario?.beneficiarioNombre ?? widget.usuario.cliente?.clienteNombre}',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Correo'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.usuario.beneficiario?.beneficiarioCorreo ??
                                  widget.usuario.cliente?.clienteCorreo ??
                                  '',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Telefono 1'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.usuario.cliente?.clienteTelefono1 ??
                                  widget.usuario.beneficiario
                                      ?.beneficiarioTelefono ??
                                  'Ninguno',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Telefono 2'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.usuario.cliente?.clienteTelefono2 ??
                                  'Ninguno',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Cedula / Pasaporte / Rnc'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.usuario.cliente?.clienteIdentificacion ??
                                  widget.usuario.beneficiario
                                      ?.beneficiarioIdentificacion ??
                                  '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  ...contentBenef,
                  const SizedBox(height: kDefaultPadding),
                  Text('Documentos (${widget.usuario.documentos?.length})'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                  ...List.generate(widget.usuario.documentos?.length ?? 0,
                      (index) {
                    var imagen = widget.usuario.documentos![index];
                    return _buildCard(imagen);
                  })
                ],
              ))),
    );
  }
}
