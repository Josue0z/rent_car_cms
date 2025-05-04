import 'package:flutter/material.dart';
import 'package:rent_car_cms/settings.dart';

class HistoryBeneficiariosView extends StatefulWidget {
  final String titleView;
  const HistoryBeneficiariosView({super.key, required this.titleView});

  @override
  State<HistoryBeneficiariosView> createState() =>
      _HistoryBeneficiariosViewState();
}

class _HistoryBeneficiariosViewState extends State<HistoryBeneficiariosView> {
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
      body: Center(
        child: Text('HISTORIES...'),
      ),
    );
  }
}
