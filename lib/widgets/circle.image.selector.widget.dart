import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleImageSelectorWidget extends StatefulWidget {
  dynamic imagen;

  double radius = 90;

  Function(Uint8List, String base64) onChanged;

  CircleImageSelectorWidget(
      {super.key, this.imagen, this.radius = 100, required this.onChanged});

  @override
  State<CircleImageSelectorWidget> createState() =>
      _CircleImageSelectorWidgetState();
}

class _CircleImageSelectorWidgetState extends State<CircleImageSelectorWidget> {
  _onPickerImage() async {
    try {
      var result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['svg']);

      if (result != null && result.files.isNotEmpty) {
        var file = File(result.files.single.path!);
        widget.imagen = await file.readAsBytes();

        widget.onChanged(widget.imagen, base64Encode(widget.imagen));
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget get content {
    if (widget.imagen is Uint8List) {
      return Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(widget.radius)),
        child: SvgPicture.memory(widget.imagen, width: 15, height: 15),
      );
    }

    if (widget.imagen is String) {
      return Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(widget.radius)),
        child: SvgPicture.memory(base64Decode(widget.imagen),
            width: 15, height: 15),
      );
    }

    return Container(
      width: widget.radius,
      height: widget.radius,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(widget.radius)),
      child: const Icon(Icons.photo_camera, color: Colors.black45),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [GestureDetector(onTap: _onPickerImage, child: content)],
    );
  }
}
