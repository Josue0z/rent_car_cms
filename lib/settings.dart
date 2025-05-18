import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/banco.cuenta.tipo.dart';
import 'package:rent_car_cms/models/banco.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var storage = const FlutterSecureStorage();

DateTime from = DateTime.now().copyWith(hour: 7, minute: 30);

DateTime to =
    DateTime.now().copyWith(hour: 15, minute: 30).add(const Duration(days: 5));

int xcurrentMakeId = 0;

int xcurrentModelId = 0;

int xcurrentProvinceId = 0;

int currentMakeIndex = 0;

int currentModelIndex = 0;

int currentProvinceIndex = 0;

int currentStartTimeIndex = 0;

int currentEndTimeIndex = 0;

num currentStartPrice = 10;

num currentEndPrice = 100;

num currentLat = 0;

num currentLong = 0;

const String kAppName = 'Cideca Manager';

const String kGoogleMapKey = 'AIzaSyA2E5v8OMj1nYWqCezRMa8PwWeSEJ2c0V8';

const double kDefaultPadding = 20;

const double kDefaultFontSized = 17;

Usuario? currentUser;

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

bool startupisHide = false;

const Color backgroundColor = Colors.white;

const Color primaryColor = Color(0xFF720F0B);

const Color secondaryColor = Color(0xFF0D7FC3);

const Color tertiaryColor = Color(0xFFD3A338);

const Color kLabelsFontColor = Color(0xFF5A5A5A);

const Color kParagraphFontColor = Color(0xFF303030);

const Color kPlaceholdersFontColor = Color(0xFFB3B3B3);

const double kTitlesFontSize = 45;

const double kLabelsFontSize = 20;

const double kLabelsFontSize2 = 18;

const double kParagraphFontSize = 18;

const double kParagraphFontSize2 = 16;

const double kPlaceholdersFontSize = 16;

const FontWeight kTitlesFontWeight = FontWeight.bold;

const FontWeight kLabelsFontWeight = FontWeight.bold;

const FontWeight kParagraphFontWeight = FontWeight.w400;

const FontWeight kPlaceholdersFontWeight = FontWeight.w500;

List<Banco> bancos = [];

List<BancoCuentaTipo> bancosCuentaTipo = [];

List<Marca> marcas = [];

List<Modelo> modelos = [];

List<ModeloVersion> modelosVersiones = [];

List<Provincia> provincias = [];

List<MyColor> colores = [];

List<TipoAuto> tiposAutos = [];

List<Combustible> combustibles = [];

List<Transmision> transmisiones = [];
