import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/cliente.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/settings.dart';

class UsersDetailsPage extends StatefulWidget {
  final Usuario usuario;
  final Beneficiario? beneficiario;
  final Cliente? cliente;
  const UsersDetailsPage(
      {super.key,
      required this.usuario,
      required this.beneficiario,
      required this.cliente});

  @override
  State<UsersDetailsPage> createState() => _UsersDetailsPageState();
}

class _UsersDetailsPageState extends State<UsersDetailsPage> {
  Widget get content {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(
              text: 'NAME: ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: widget.beneficiario?.beneficiarioNombre ??
                  widget.cliente?.clienteNombre ??
                  'S/N')
        ])),
        const SizedBox(height: kDefaultPadding),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: 'IDENTIFICATION: ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: widget.beneficiario?.beneficiarioIdentificacion ??
                  widget.cliente?.clienteIdentificacion ??
                  'S/N')
        ])),
        const SizedBox(height: kDefaultPadding),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: 'ADDRESS: ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(text: widget.beneficiario?.beneficiarioDireccion ?? 'S/N')
        ])),
        const SizedBox(height: kDefaultPadding),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: 'PHONE 1: ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(text: widget.cliente?.clienteTelefono1 ?? 'S/N')
        ])),
        const SizedBox(height: kDefaultPadding),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: 'PHONE 2: ',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500)),
          TextSpan(text: widget.cliente?.clienteTelefono2 ?? 'S/N')
        ])),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.usuario.usuarioLogin ?? 'USER DETAILS'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [content],
              ))),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('DECLINE USER'))),
            const SizedBox(width: kDefaultPadding / 2),
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 233, 253, 234))),
              child: const Text('ACEPTED USER', style: TextStyle(
                color: Colors.green
              ),),
            ))
          ],
        ),
      ),
    );
  }
}
