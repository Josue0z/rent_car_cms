import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/settings.dart';

class _BuildCard extends StatelessWidget {
  VoidCallback? onDelete;

  dynamic imagen;

  void Function(Object?)? onSelected;

  void Function(Object?)? onSelected2;

  int index;

  _BuildCard({required this.imagen, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned.fill(
                  child: imagen is Uint8List
                      ? Image.memory(imagen, fit: BoxFit.cover)
                      : Image.network(imagen.urlImagen, fit: BoxFit.cover)),
              Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Center(
                        child: Icon(Icons.delete,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

class ImagenSelectorWidget extends StatefulWidget {
  List<ImagenModel>? imagenes = [];

  final String labelText;
  Function(List<ImagenModel> imagenes) onChanged;

  ImagenSelectorWidget(
      {super.key,
      this.imagenes,
      this.labelText = 'Cargar Imagenes...',
      required this.onChanged});

  @override
  State<ImagenSelectorWidget> createState() => _ImagenSelectorWidgetState();
}

class _ImagenSelectorWidgetState extends State<ImagenSelectorWidget> {
  List<XFile> xfiles = [];

  List<Widget> widgets = [];

  _renderWidgets() {
    for (int i = 0; i < widget.imagenes!.length; i++) {
      var img = widget.imagenes![i];
      widgets.add(_BuildCard(imagen: img, index: i));
    }
    print(widget.imagenes);
    setState(() {});
  }

  _onPicker() async {
    final ImagePicker picker = ImagePicker();
    var xxfiles = await picker.pickMultiImage();
    for (int i = 0; i < xxfiles.length; i++) {
      var file = xxfiles[i];
      var bytes = await file.readAsBytes();
      var base64 = base64Encode(bytes);
      var imagen = ImagenModel(
        imagenBase64: base64,
      );
      widget.imagenes?.add(imagen);

      var xwidget = _BuildCard(imagen: bytes, index: i);
      xwidget.onDelete = () {
        widget.imagenes?.remove(imagen);
        xfiles.remove(file);
        widgets.remove(xwidget);
        widget.onChanged(widget.imagenes!);
        setState(() {});
      };
      xwidget.onSelected = (id) {
        widget.onChanged(widget.imagenes!);
      };

      widgets.add(xwidget);
    }
    xfiles.addAll(xxfiles);

    widget.onChanged(widget.imagenes!);

    setState(() {});
  }

  @override
  void initState() {
    _renderWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagenes!.isNotEmpty) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: kDefaultPadding),
        Text(
          '${'Imagenes'.tr} (${widget.imagenes?.length})',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        ...List.generate(widgets.length, (index) {
          return widgets[index];
        }),
      ]);
    }
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            child: InkWell(
              onTap: _onPicker,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.labelText,
                        style: const TextStyle(color: kLabelsFontColor))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
