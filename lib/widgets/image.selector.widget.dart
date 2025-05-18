import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageSelectorWidget extends FormField<Map<String, dynamic>?> {
  ImageSelectorWidget({
    super.key,
    FormFieldSetter<Map<String, dynamic>?>? onChanged,
    FormFieldValidator<Map<String, dynamic>?>? validator,
    Map<String, dynamic>? initialValue,
  }) : super(
            initialValue: initialValue,
            validator: validator,
            onSaved: onChanged,
            builder: (state) {
              Map<String, dynamic>? value = initialValue ?? state.value;

              double h = 200;

              onPickerImage() async {
                try {
                  var result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['jpg']);

                  if (result == null) {
                    state.didChange(null);
                    state.save();
                    state.validate();
                    return;
                  }

                  if (result.files.isNotEmpty) {
                    var file = File(result.files.single.path!);
                    var bytes = await file.readAsBytes();

                    state.didChange(
                        {'bytes': bytes, 'imagenBase64': base64Encode(bytes)});
                    state.save();

                    state.validate();
                  }
                } catch (e) {
                  print(e);
                }
              }

              Widget content() {
                if (!state.hasError &&
                    value != null &&
                    value['bytes'] is Uint8List) {
                  return Container(
                      width: double.infinity,
                      height: h,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Image.memory(value['bytes'], fit: BoxFit.cover),
                      ));
                }

                if (!state.hasError &&
                    value != null &&
                    value['imagenBase64'] is String) {
                  return Container(
                      width: double.infinity,
                      height: h,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Image.memory(base64Decode(value['imagenBase64']),
                            fit: BoxFit.cover),
                      ));
                }

                return SizedBox(
                  width: double.infinity,
                  height: h,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Icon(Icons.image_outlined,
                          color: Colors.black26, size: 80),
                    ),
                  ),
                );
              }

              return LayoutBuilder(builder: (ctx, c) {
                return GestureDetector(
                    onTap: onPickerImage,
                    child: SizedBox(
                      width: c.maxWidth - kDefaultPadding,
                      child: Column(
                        children: [
                          content(),
                          const SizedBox(
                            height: kDefaultPadding / 2,
                          ),
                          Text(state.hasError ? state.errorText! : '',
                              style: const TextStyle(color: Colors.red))
                        ],
                      ),
                    ));
              });
            });
}
