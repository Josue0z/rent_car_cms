import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/reserva.dart';
import 'package:rent_car_cms/pages/booking.details_page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeClientsBookingsView extends StatefulWidget {
  final String titleView;
  const MeClientsBookingsView({super.key, required this.titleView});

  @override
  State<MeClientsBookingsView> createState() => _MeClientsBookingsViewState();
}

class _MeClientsBookingsViewState extends State<MeClientsBookingsView> {
  late Future<List<Reserva>> future;
  late UIController uiController = Get.find<UIController>();

  _showBooking(Reserva booking) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => BookingDetailsPage(booking: booking)));
  }

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorView(Object error) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning,
                    size: 100, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: kDefaultPadding),
                Text(error.toString(),
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                const SizedBox(height: kDefaultPadding),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        future = Reserva.getBookings();
                      });
                    },
                    child: const Text('REFRESH'))
              ],
            )));
  }

  Widget contentView(List<Reserva> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svgs/undraw_date_picker_re_r0p8.svg',
                width: 270)
          ],
        ),
      );
    }
    return ListView.separated(
        itemCount: bookings.length,
        separatorBuilder: (ctx, index) => const Divider(),
        itemBuilder: (ctx, index) {
          var booking = bookings[index];
          String statusLabel = booking.reservaEstatus == 1
              ? 'PENDING'
              : booking.reservaEstatus == 2
                  ? 'ACEPTED'
                  : 'REJECTED';

          Color ccolor = booking.reservaEstatus == 1
              ? Colors.blueGrey
              : booking.reservaEstatus == 2
                  ? const Color(0xFF2C9D30)
                  : Colors.red;
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.car_rental_outlined,
                  color: Theme.of(context).primaryColor),
            ),
            title: Text('B-NUM-${booking.reservaId.toString()}'),
            subtitle: Text(
                '${booking.reservaEntregaDireccion}\n---\n${booking.reservaRecogidaDireccion}'),
            trailing: Wrap(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: 100,
                  decoration: BoxDecoration(
                      color: ccolor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ccolor)),
                  child: Text(statusLabel.toUpperCase(),
                      style:
                          TextStyle(color: ccolor, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () => _showBooking(booking),
                    icon: const Icon(Icons.visibility_outlined))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    if (!mounted) return;
    setState(() {
      future = Reserva.getBookings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey(widget.titleView),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        title: Text(widget.titleView),
      ),
      body: FutureBuilder(
          future: future,
          builder: (ctx, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return loadingView;
            }
            if (s.hasError || s.data == null) {
              return errorView(s.error!);
            }
            return contentView(s.data!);
          }),
    );
  }
}
