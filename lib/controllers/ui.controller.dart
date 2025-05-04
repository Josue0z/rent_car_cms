import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/models/user.logged.model.dart';
import 'package:rent_car_cms/models/usuario.dart';

class UIController extends GetxController {
  Rx<Usuario?> usuario = Usuario().obs;
  Rx<UserLoggedModel?> currentUserLoggedModel = Rx(null);
  RxBool logged = false.obs;

  TextEditingController name = TextEditingController();

  TextEditingController iden = TextEditingController();

  TextEditingController address = TextEditingController();
}
