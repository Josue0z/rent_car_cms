import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';

class ImagenModelMetaData {
  List<ImagenModel> imagenes;
  String? errorEvent;
  ImagenModelMetaData({required this.imagenes, this.errorEvent});
}

class _BuildCard extends StatelessWidget {
  VoidCallback? onDelete;

  ImagenModel imagen;

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
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned.fill(
                  child: imagen.imagenId != null
                      ? Image.network(imagen.urlImagen, fit: BoxFit.cover)
                      : Image.memory(base64Decode(imagen.imagenBase64!),
                          fit: BoxFit.cover)),
              imagen.imagenEstatus != null
                  ? Positioned(
                      right: 20,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                            color: imagen.color,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(imagen.imagenEstatusLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: kLabelsFontWeight)),
                      ))
                  : const Positioned(child: SizedBox()),
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
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class ImagenSelectorWidget extends FormField<ImagenModelMetaData?> {
  ImagenSelectorWidget({
    super.key,
    required BuildContext context,
    FormFieldSetter<ImagenModelMetaData>? onChanged,
    FormFieldValidator<ImagenModelMetaData>? validator,
    ImagenModelMetaData? initialValue,
    labelText = 'Cargar Imagenes... (1920×1100)',
  }) : super(
            initialValue: initialValue,
            onSaved: onChanged,
            validator: validator,
            builder: (state) {
              List<ImagenModel> imagenes =
                  (initialValue ?? state.value)?.imagenes ?? [];

              onPicker() async {
                ImagenModelMetaData data =
                    ImagenModelMetaData(imagenes: imagenes);
                final ImagePicker picker = ImagePicker();
                var xxfiles = await picker.pickMultiImage();
                for (int i = 0; i < xxfiles.length; i++) {
                  var file = xxfiles[i];
                  var bytes = await file.readAsBytes();
                  var base64 = base64Encode(bytes);
                  var imagen = ImagenModel(imagenBase64: base64);

                  var ximg = await decodeImageFromList(bytes);

                  if (ximg.width != 1920 && ximg.height != 1100) {
                    data.imagenes = [];
                    data.errorEvent = 'IMAGE_SIZE_NOT_ALLOWED';
                    state.didChange(data);
                    state.save();
                    state.validate();
                  }

                  imagenes.add(imagen);
                }
                if (data.errorEvent == null) {
                  data.imagenes = imagenes;
                  state.didChange(data);
                  state.save();
                  state.validate();
                }
              }

              if (imagenes.isNotEmpty) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: kDefaultPadding),
                      Text(
                        '${'Imagenes'.tr} (${imagenes.length})',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      ...List.generate(imagenes.length, (index) {
                        var img = imagenes[index];
                        var xwidget = _BuildCard(imagen: img, index: index);
                        xwidget.onDelete = () async {
                          try {
                            if (img.imagenId != null) {
                              showLoader(context);
                              await img.delete();
                              Navigator.pop(context);
                            }

                            imagenes.remove(img);
                            state.didChange(
                                ImagenModelMetaData(imagenes: imagenes));
                            state.save();
                            state.validate();
                          } catch (e) {
                            Navigator.pop(context);
                            showSnackBar(context, e.toString());
                          }
                        };
                        return xwidget;
                      }),
                      const SizedBox(height: kDefaultPadding),
                      AppCustomButton(
                          outlineEnabled: true,
                          onPressed: () {
                            onPicker();
                          },
                          children: const [Text('CARGAR MAS IMAGENES')])
                    ]);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DottedBorder(
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      dashPattern: const [5, 8],
                      color: Colors.black54,
                      child: SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            child: Ink(
                              child: InkWell(
                                onTap: onPicker,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image_outlined,
                                          size: 130, color: Colors.black12),
                                      const SizedBox(height: kDefaultPadding),
                                      Text(labelText,
                                          style: const TextStyle(
                                              color: kLabelsFontColor))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))),
                  const SizedBox(height: kDefaultPadding),
                  Text(state.hasError ? state.errorText ?? '' : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error))
                ],
              );
            });
}
