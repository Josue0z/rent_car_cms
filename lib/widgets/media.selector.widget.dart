import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image/image.dart' as img;

class MediaSelectorWidget extends StatefulWidget {
  List<Documento>? documentos;

  List<Map<String, dynamic>> documentsTypes = [
    {
      "documentoId": 5,
      "documentoTipo": 2,
      "documentoNombre": "Cedula / Pasaporte",
      "documentoDescripcion": "Indique su documento de identidad o pasaporte",
      "documentoEstatus": 1
    }
  ];

  Function(List<Documento> documentos) onChanged;

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

  List<TextEditingController> editors1 = [];

  List<TextEditingController> editors2 = [];

  renderDocuments() {
    if (widget.documentos != null && widget.documentos!.isNotEmpty) {
      for (int i = 0; i < widget.documentos!.length; i++) {
        var documento = widget.documentos![i];
        var editor1 = TextEditingController();
        var editor2 = TextEditingController();

        editors1.add(editor1);
        editors2.add(editor2);

        var xwidget = MediaItemWidget(
            documentsTypes: widget.documentsTypes,
            imagenBytes: base64Decode(documento.imagenBase64!),
            documentoId: documento.documentoId,
            editorController1: editor1,
            editorController2: editor2);

        editor1.value = TextEditingValue(text: documento.imagenNota ?? '');
        editor2.value = TextEditingValue(text: documento.imagenContenido ?? '');

        items.add(xwidget);
      }

      for (int i = 0; i < widget.documentos!.length; i++) {
        var editor1 = editors1[i];
        var editor2 = editors2[i];

        editor1.addListener(() {
          widget.documentos![i].imagenNota = editor1.text;
          widget.onChanged(widget.documentos!);
        });

        editor2.addListener(() {
          widget.documentos![i].imagenContenido = editor2.text;
          widget.onChanged(widget.documentos!);
        });
      }

      widget.onChanged(widget.documentos!);

      setState(() {});
    }
  }

  uploadMedia() async {
    List<Documento> xdocumentos = [];

    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    var files = result?.files;

    if (files != null) {
      for (int ii = 0; ii < files.length; ii++) {
        var file = files[ii];

        var bytes = await file.xFile.readAsBytes();
        var editor1 = TextEditingController();
        var editor2 = TextEditingController();

        editors1.add(editor1);
        editors2.add(editor2);

        var xwidget = MediaItemWidget(
            imagenBytes: bytes,
            documentsTypes: widget.documentsTypes,
            editorController1: editor1,
            editorController2: editor2);

        final image = img.decodeImage(bytes);
        //final resized = img.copyResize(image!, width: 80);
        final resizedByteData = img.encodeJpg(image!);
        var btes = ByteData.sublistView(resizedByteData);
        var imagenBase64 = base64Encode(btes.buffer.asUint8List());
        var imagenContenido = 'data:image/jpeg;base64,$imagenBase64';

        var doc = Documento(
            imagenNota: '',
            imagenContenido: imagenContenido,
            imagenFecha: DateTime.now().toIso8601String(),
            imagenEstatus: 1,
            imagenBase64: imagenBase64,
            imagenPrincipal: 1);

        xdocumentos.add(doc);

        items.add(xwidget);
      }
    }
    widget.documentos = [...?widget.documentos, ...xdocumentos];

    for (int i = 0; i < editors1.length; i++) {
      var editor1 = editors1[i];

      editor1.addListener(() {
        widget.documentos![i].imagenNota = editor1.text;
        widget.onChanged(widget.documentos!);
      });
    }

    for (int i = 0; i < editors2.length; i++) {
      var editor2 = editors2[i];

      editor2.addListener(() {
        widget.documentos![i].imagenContenido = editor2.text;
        widget.onChanged(widget.documentos!);
      });
    }

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
                    const Text('UPLOAD DOCUMENTS (NACIONAL ID, PASSPORT)')
                  ],
                ),
              ),
            )));

    for (int i = 0; i < items.length; i++) {
      var item = items[i] as MediaItemWidget;
      item.onDelete = () {
        items.removeAt(i);
        widget.documentos?.removeAt(i);
        editors1.removeAt(i);
        editors2.removeAt(i);
        setState(() {});
        widget.onChanged(widget.documentos!);
      };
      item.onChanged = (id) {
        widget.documentos![i].documentoId = id;
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
                child: const Text('LOAD MORE DOCUMENTS')),
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

  final Uint8List imagenBytes;

  final TextEditingController editorController1;

  final TextEditingController editorController2;

  VoidCallback? onDelete;

  Function(int documentoId)? onChanged;

  List<Map<String, dynamic>> documentsTypes = [];

  MediaItemWidget(
      {super.key,
      this.documentoId,
      this.onDelete,
      this.onChanged,
      required this.documentsTypes,
      required this.imagenBytes,
      required this.editorController1,
      required this.editorController2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.memory(imagenBytes, fit: BoxFit.cover)),
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
                hintText: 'DOCUMENT TYPE', border: OutlineInputBorder()),
            items: documentsTypes.map((e) {
              return DropdownMenuItem(
                  value: e['documentoId'] as int,
                  child: Text(e['documentoNombre']));
            }).toList(),
            onChanged: (id) {
              onChanged!(id!);
            }),
        const SizedBox(height: kDefaultPadding),
        TextFormField(
          controller: editorController1,
          decoration: const InputDecoration(
              labelText: 'NOTE',
              hintText: 'NOTE...',
              border: OutlineInputBorder()),
        ),
        const SizedBox(height: kDefaultPadding),
        TextFormField(
          controller: editorController2,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: const InputDecoration(
              labelText: 'CONTENT',
              hintText: 'CONTENT...',
              border: OutlineInputBorder()),
        ),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
