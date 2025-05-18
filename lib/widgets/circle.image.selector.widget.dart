import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as path;
import 'package:rent_car_cms/settings.dart';

class CircleImageSelectorWidget extends FormField<Map<String, dynamic>?> {
  CircleImageSelectorWidget({
    super.key,
    FormFieldSetter<Map<String, dynamic>?>? onChanged,
    FormFieldValidator<Map<String, dynamic>?>? validator,
    double radius = 90.00,
    Map<String, dynamic>? initialValue,
  }) : super(
            initialValue: initialValue,
            validator: validator,
            onSaved: onChanged,
            builder: (state) {
              Map<String, dynamic>? value = initialValue ?? state.value;

              onPickerImage() async {
                try {
                  var result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['svg']);

                  if (result != null && result.files.isNotEmpty) {
                    var file = File(result.files.single.path!);
                    var bytes = await file.readAsBytes();
                    var exts = path.extension(file.path);
                    if (exts.toLowerCase() != '.svg') {
                      state.didChange(null);
                      state.save();
                      state.validate();
                      return;
                    }

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
                      width: radius,
                      height: radius,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(radius)),
                      child: Center(
                        child: SvgPicture.memory(value['bytes'],
                            width: 54, height: 54, color: secondaryColor),
                      ));
                }

                if (!state.hasError &&
                    value != null &&
                    value['imagenBase64'] is String) {
                  return Container(
                      width: radius,
                      height: radius,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(radius)),
                      child: Center(
                        child: SvgPicture.memory(
                          base64Decode(value['imagenBase64']),
                          width: 54,
                          height: 54,
                          color: secondaryColor,
                        ),
                      ));
                }

                return Container(
                  width: radius,
                  height: radius,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(radius)),
                  child: const Icon(Icons.image, color: Colors.black45),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: onPickerImage,
                      child: Column(
                        children: [
                          content(),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(state.hasError ? state.errorText! : '',
                              style: const TextStyle(color: Colors.red))
                        ],
                      ))
                ],
              );
            });
}
