import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:rent_car_cms/models/reserva.dart';
import 'package:rent_car_cms/settings.dart';

class BookingDetailsPage extends StatefulWidget {
  final Reserva booking;

  BookingDetailsPage({super.key, required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('B-NUM-${widget.booking.reservaId.toString()}'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Text(
              widget.booking.reservaEstatus == 1
                  ? 'PENDING'
                  : widget.booking.reservaEstatus == 2
                      ? 'ACEPTED'
                      : widget.booking.reservaEstatus == 3
                          ? 'REJECT'
                          : '',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: kDefaultPadding / 2)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kDefaultPadding),
            Text(
              'START ADDRESS',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(widget.booking.reservaRecogidaDireccion!),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              'START DATETIME',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(widget.booking.reservaFhInicial!),
            const Divider(),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              'END ADDRESS',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(widget.booking.reservaEntregaDireccion!),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              'END DATETIME',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Text(widget.booking.reservaFhFinal!),
            const SizedBox(height: kDefaultPadding / 2),
            const Divider(),
            const SizedBox(height: kDefaultPadding / 2),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'ABONO PAGADO (30%) ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "\$" + widget.booking.reservaAbono!.toStringAsFixed(2))
            ])),
            const SizedBox(height: kDefaultPadding / 2),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'DEBT ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "\$" +
                      (widget.booking.reservaMontoTotal! -
                              widget.booking.reservaAbono!)
                          .toStringAsFixed(2))
            ])),
            const SizedBox(height: kDefaultPadding / 2),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'ITBIS (18%) ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "\$" +
                      (widget.booking.reservaMontoTotal! * 0.18)
                          .toStringAsFixed(2))
            ])),
            const SizedBox(height: kDefaultPadding / 2),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'TOTAL ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "\$" +
                      widget.booking.reservaMontoTotal!.toStringAsFixed(2))
            ])),
            const SizedBox(height: kDefaultPadding / 2),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: Row(
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0x47C2C2C2))),
                onPressed: () {},
                child: const Text(
                  'REJECT BOOKING',
                  style: TextStyle(color: Color(0xFF6A6A6A)),
                )),
            const SizedBox(width: kDefaultPadding / 2),
            ElevatedButton(
                onPressed: () {}, child: const Text('ACCEPT BOOKING'))
          ],
        ),
      ),
    );
  }
}
