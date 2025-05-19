import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CidecaLogoWidget extends StatelessWidget {
  const CidecaLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('./assets/svgs/cideca-logo.svg', width: 80);
  }
}
