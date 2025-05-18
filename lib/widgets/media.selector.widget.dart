import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image/image.dart' as img;

class MediaSelectorWidget extends StatefulWidget {
  List<DocumentoModel>? documentos;

  List<Map<String, dynamic>> documentsTypes = [
    {
      "documentoId": 5,
      "documentoTipo": 2,
      "documentoNombre": "Cedula / Pasaporte",
      "documentoDescripcion": "Indique su documento de identidad o pasaporte",
      "documentoEstatus": 1
    }
  ];

  Function(List<DocumentoModel> documentos) onChanged;

  MediaSelectorWidget(
      {super.key,
      this.documentos,
      required this.documentsTypes,
      required this.onChanged});

  @override
  State<MediaSelectorWidget> createState() => _MediaSelectorWidgetState();
}

class _MediaSelectorWidgetState extends State<MediaSelectorWidget> {
  List<Widget> items = [];

  renderDocuments() {
    if (widget.documentos != null && widget.documentos!.isNotEmpty) {
      for (int i = 0; i < widget.documentos!.length; i++) {
        var documento = widget.documentos![i];

        var xwidget = MediaItemWidget(
          documentsTypes: widget.documentsTypes,
          documento: documento,
          documentoId: documento.documentoId,
        );

        items.add(xwidget);
      }

      widget.onChanged(widget.documentos!);

      setState(() {});
    }
  }

  uploadMedia() async {
    List<DocumentoModel> xdocumentos = [];

    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf']);
    var files = result?.files;

    if (files != null) {
      for (int ii = 0; ii < files.length; ii++) {
        var file = files[ii];

        var bytes = await file.xFile.readAsBytes();

        var imagenBase64 = base64Encode(bytes);

        int tipo = 1;

        print(file.extension);

        if (file.extension?.toLowerCase().contains('pdf') == true) {
          tipo = 2;
        }

        var doc = DocumentoModel(
            imagenBase64: imagenBase64, documentoFormatoId: tipo);

        xdocumentos.add(doc);

        var xwidget = MediaItemWidget(
            documento: doc, documentsTypes: widget.documentsTypes);

        items.add(xwidget);
      }
    }
    widget.documentos = [...?widget.documentos, ...xdocumentos];

    widget.onChanged(widget.documentos!);

    setState(() {});
  }

  @override
  void initState() {
    renderDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget w1 = Container();

    w1 = GestureDetector(
        onTap: uploadMedia,
        child: DottedBorder(
            dashPattern: const [10, 5, 0, 3],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image,
                        size: 60, color: Theme.of(context).primaryColor),
                    const SizedBox(height: kDefaultPadding / 2),
                    const Text(
                        'SUBIR DOCUMENTOS (CEDULA O PASAPORTE Y CERTIFICACION DE INSCRIPCION DEL CONTRIBUYENTE DE LA DGII)',
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            )));

    for (int i = 0; i < items.length; i++) {
      var item = items[i] as MediaItemWidget;
      item.onDelete = () {
        items.removeAt(i);
        widget.documentos?.removeAt(i);
        setState(() {});
        widget.onChanged(widget.documentos!);
      };
      item.onChanged = (id) {
        widget.documentos?[i].documentoTipo = id;
        widget.onChanged(widget.documentos!);
      };
    }

    if (widget.documentos != null && widget.documentos!.isNotEmpty) {
      w1 = SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...items,
          const SizedBox(height: kDefaultPadding),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: uploadMedia,
                child: const Text('CARGAR MAS DOCUMENTOS')),
          )
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DOCUMENTS (${widget.documentos?.length ?? 0})',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 19,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: kDefaultPadding),
        w1
      ],
    );
  }
}

class MediaItemWidget extends StatelessWidget {
  final int? documentoId;

  final DocumentoModel? documento;

  VoidCallback? onDelete;

  Function(int documentoId)? onChanged;

  List<Map<String, dynamic>> documentsTypes = [];

  MediaItemWidget(
      {super.key,
      this.documentoId,
      this.onDelete,
      this.onChanged,
      required this.documentsTypes,
      required this.documento});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12)),
          child: Stack(
            children: [
              Positioned.fill(
                  child: documento?.documentoFormatoId == 1
                      ? Image.memory(
                          base64Decode(documento?.imagenBase64 ?? ''),
                          fit: BoxFit.cover)
                      : Center(
                          child: Icon(Icons.picture_as_pdf,
                              size: 120,
                              color: Theme.of(context).colorScheme.primary),
                        )),
              Positioned(
                  top: 15,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: onDelete,
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.delete)),
                  ))
            ],
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        DropdownButtonFormField(
            value: documentoId,
            isExpanded: true,
            decoration: const InputDecoration(
                hintText: 'DOCUMENTO TIPO', border: OutlineInputBorder()),
            items: documentsTypes.map((e) {
              return DropdownMenuItem(
                  value: e['documentoTipo'] as int,
                  child: Text(e['documentoNombre']));
            }).toList(),
            onChanged: (id) {
              onChanged!(id!);
            }),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
