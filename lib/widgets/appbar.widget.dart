import 'package:flutter/material.dart';
import 'package:rent_car_cms/settings.dart';

class AppBarWidget extends AppBar {
  AppBarWidget(
      {super.key,
      required BuildContext context,
      String title = '',
      Widget? leading,
      PreferredSize? bottom,
      List<Widget>? actions})
      : super(
            elevation: 0,
            leading: Navigator.canPop(context)
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back))
                : scaffoldKey.currentState!.hasDrawer
                    ? IconButton(
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu))
                    : leading,
            bottom: bottom ??
                PreferredSize(
                    preferredSize: const Size.fromHeight(5),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      decoration: const BoxDecoration(color: Colors.black12),
                    )),
            backgroundColor: Colors.transparent,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            title: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26, spreadRadius: 1, blurRadius: 5)
                    ]),
                child: Text(title,
                    style: Theme.of(context).textTheme.displaySmall),
              ),
            ),
            actions: actions);
}
