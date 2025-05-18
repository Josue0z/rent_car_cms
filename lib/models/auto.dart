// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/megusta.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/models/precio.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/settings.dart';

class Auto {
  int? autoId;
  int? tipoId;
  TipoAuto? tipoAuto;
  String? tipoNombre;
  int? marcaId;
  String? marcaNombre;
  Marca? marca;
  int? modeloId;
  String? modeloNombre;
  Modelo? modelo;
  int? colorId;
  MyColor? color;
  String? colorNombre;
  int? autoAno;
  String? autoDescripcion;
  int? beneficiarioId;
  Beneficiario? beneficiario;
  String? beneficiarioNombre;
  String? autoFecha;
  int? autoEstatus;
  int? paisId;
  String? paisNombre;
  int? provinciaId;
  Provincia? provincia;
  String? provinciaNombre;
  int? ciudadId;
  Ciudad? ciudad;
  String? ciudadNombre;
  String? autoDireccion;
  num? autoCoorX;
  num? autoCoorY;
  int? precioId;
  num? precio;
  num? precioPlataforma;
  int? seguroId;
  String? seguroNombre;
  int? autoTransmision;
  int? autoDondeSea;
  String? autoCondiciones;
  int? autoKmIncluido;
  int? imagen;
  String? urlImagenPrincipal;
  List<ImagenModel>? imagenesColeccion;
  num? valoracion;
  List<Valoracion>? valoraciones;
  num? precioViejo;
  String? hexColor;
  num? autoNumeroViajes;
  int? autoNumeroPersonas;
  int? autoNumeroPuertas;
  int? autoNumeroAsientos;
  String? autoTipoNombre;
  String?
      svgMarca; // es el svg string que hace referencia al logo de la marca del auto se determina gracias al valor de marcaId
  int? factorFormaId;
  String? factorFormaNombre;
  List<ImagenModel>?
      imagenesTransparentes; // imagenes que son definidas en la base de datos que se asocia al objeto auto gracias a las propiedades marcaId, modeloId y colorId por lo tanto lo ideal es crear otra tabla para estas relaciones
  int? transmisionId;
  Transmision? transmision;
  List<AutoMegustaModel>? autosMeGustas;

  int? modeloVersionId;
  ModeloVersion? modeloVersion;

  int? combustibleId;

  Combustible? combustible;

  Auto(
      {this.autoId,
      this.tipoId,
      this.tipoAuto,
      this.tipoNombre,
      this.marcaId,
      this.marcaNombre,
      this.modeloId,
      this.modeloNombre,
      this.colorId,
      this.color,
      this.colorNombre,
      this.autoAno,
      this.autoDescripcion,
      this.beneficiarioId,
      this.beneficiario,
      this.beneficiarioNombre,
      this.autoFecha,
      this.autoEstatus,
      this.paisId,
      this.paisNombre,
      this.provinciaId,
      this.provinciaNombre,
      this.ciudadId,
      this.ciudadNombre,
      this.autoDireccion,
      this.autoCoorX,
      this.autoCoorY,
      this.precioId,
      this.precio,
      this.precioPlataforma,
      this.seguroId,
      this.seguroNombre,
      this.autoTransmision,
      this.autoDondeSea,
      this.autoCondiciones,
      this.autoKmIncluido,
      this.imagen,
      this.urlImagenPrincipal,
      this.imagenesColeccion,
      this.valoracion,
      this.valoraciones,
      this.svgMarca,
      this.precioViejo,
      this.autoNumeroViajes,
      this.hexColor,
      this.imagenesTransparentes,
      this.autoNumeroPersonas,
      this.autoNumeroPuertas,
      this.autoNumeroAsientos,
      this.autoTipoNombre,
      this.factorFormaId,
      this.marca,
      this.modelo,
      this.factorFormaNombre,
      this.provincia,
      this.ciudad,
      this.transmisionId,
      this.transmision,
      this.autosMeGustas,
      this.modeloVersionId,
      this.modeloVersion,
      this.combustibleId,
      this.combustible});

  String get modeloNombreDisplay {
    if (modeloVersion != null) {
      return modeloVersion?.versionNombre ?? '';
    }

    return modelo?.modeloNombre ?? '';
  }

  String get title {
    return '${marca?.marcaNombre} $modeloNombreDisplay $autoAno';
  }

  String get estadoNombre {
    if (autoEstatus == 1) {
      return 'Disponible'.tr;
    }

    if (autoEstatus == 2) {
      return 'No disponible'.tr;
    }

    if (autoEstatus == 3) {
      return 'En Revision'.tr;
    }
    return '<None>';
  }

  String get transmisionLabel {
    if (transmisionId == 1) {
      return 'Automatica'.tr;
    }
    if (transmisionId == 2) {
      return 'Manual'.tr;
    }
    return '<None>';
  }

  Color get colorEstatus {
    if (autoEstatus == 1) {
      return Colors.green;
    }

    if (autoEstatus == 2) {
      return primaryColor;
    }

    if (autoEstatus == 3) {
      return tertiaryColor;
    }
    return Colors.transparent;
  }

  static Future<Auto> findById({required int autoId}) async {
    try {
      var res = await rentApi.get('/autos/$autoId');
      return Auto.fromMap(res.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Auto>> get(
      {pagina = 1,
      cantidad = 10,
      marcaId = 0,
      modeloId = 0,
      modeloVersionId = 0,
      estado = 0,
      beneficiarioId = 0}) async {
    try {
      var res = await rentApi.get(
          '/autos/todos?beneficiarioId=$beneficiarioId&marcaId=$marcaId&modeloId=$modeloId&modeloVersionId=$modeloVersionId&estado=$estado');

      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Auto.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Auto?> create() async {
    try {
      var res = await rentApi.post('/autos/crear', data: toMap());
      if (res.statusCode == 200) {
        return Auto.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Auto?> update() async {
    try {
      var res = await rentApi.put('/autos/modificar/$autoId', data: toMap());
      if (res.statusCode == 200) {
        return Auto.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Auto copyWith(
      {int? autoId,
      int? tipoId,
      String? tipoNombre,
      int? marcaId,
      String? marcaNombre,
      int? modeloId,
      String? modeloNombre,
      int? colorId,
      String? colorNombre,
      int? autoAno,
      String? autoDescripcion,
      int? beneficiarioId,
      String? beneficiarioNombre,
      String? autoFecha,
      int? autoEstatus,
      int? paisId,
      String? paisNombre,
      int? provinciaId,
      String? provinciaNombre,
      int? ciudadId,
      String? ciudadNombre,
      String? autoDireccion,
      num? autoCoorX,
      num? autoCoorY,
      int? precioId,
      num? precioPlataforma,
      int? seguroId,
      String? seguroNombre,
      int? autoTransmision,
      int? autoDondeSea,
      String? autoCondiciones,
      int? autoKmIncluido,
      int? imagen,
      String? urlImagenPrincipal,
      List<ImagenModel>? imagenesColeccion,
      num? valoracion,
      List<Valoracion>? valoraciones,
      String? svgMarca,
      num? precioViejo,
      num? autoNumeroViajes,
      String? hexColor,
      List<ImagenModel>? imagenesTransparentes,
      int? autoNumeroPersonas,
      int? autoNumeroPuertas,
      int? autoNumeroAsientos,
      String? autoTipoNombre,
      int? factorFormaId}) {
    return Auto(
        autoId: autoId ?? this.autoId,
        tipoId: tipoId ?? this.tipoId,
        tipoNombre: tipoNombre ?? this.tipoNombre,
        marcaId: marcaId ?? this.marcaId,
        marcaNombre: marcaNombre ?? this.marcaNombre,
        modeloId: modeloId ?? this.modeloId,
        modeloNombre: modeloNombre ?? this.modeloNombre,
        colorId: colorId ?? this.colorId,
        colorNombre: colorNombre ?? this.colorNombre,
        autoAno: autoAno ?? this.autoAno,
        autoDescripcion: autoDescripcion ?? this.autoDescripcion,
        beneficiarioId: beneficiarioId ?? this.beneficiarioId,
        beneficiarioNombre: beneficiarioNombre ?? this.beneficiarioNombre,
        autoFecha: autoFecha ?? this.autoFecha,
        autoEstatus: autoEstatus ?? this.autoEstatus,
        paisId: paisId ?? this.paisId,
        paisNombre: paisNombre ?? this.paisNombre,
        provinciaId: provinciaId ?? this.provinciaId,
        provinciaNombre: provinciaNombre ?? this.provinciaNombre,
        ciudadId: ciudadId ?? this.ciudadId,
        ciudadNombre: ciudadNombre ?? this.ciudadNombre,
        autoDireccion: autoDireccion ?? this.autoDireccion,
        autoCoorX: autoCoorX ?? this.autoCoorX,
        autoCoorY: autoCoorY ?? this.autoCoorY,
        precioId: precioId ?? this.precioId,
        precioPlataforma: precioPlataforma ?? this.precioPlataforma,
        seguroId: seguroId ?? this.seguroId,
        seguroNombre: seguroNombre ?? this.seguroNombre,
        autoTransmision: autoTransmision ?? this.autoTransmision,
        autoDondeSea: autoDondeSea ?? this.autoDondeSea,
        autoCondiciones: autoCondiciones ?? this.autoCondiciones,
        autoKmIncluido: autoKmIncluido ?? this.autoKmIncluido,
        imagen: imagen ?? this.imagen,
        urlImagenPrincipal: urlImagenPrincipal ?? this.urlImagenPrincipal,
        imagenesColeccion: imagenesColeccion ?? this.imagenesColeccion,
        valoracion: valoracion ?? this.valoracion,
        valoraciones: valoraciones ?? this.valoraciones,
        svgMarca: svgMarca ?? this.svgMarca,
        precioViejo: precioViejo ?? this.precioViejo,
        autoNumeroViajes: autoNumeroViajes ?? this.autoNumeroViajes,
        hexColor: hexColor ?? this.hexColor,
        imagenesTransparentes:
            imagenesTransparentes ?? this.imagenesTransparentes,
        autoNumeroPersonas: autoNumeroPersonas ?? this.autoNumeroPersonas,
        autoNumeroPuertas: autoNumeroPuertas ?? this.autoNumeroPuertas,
        autoNumeroAsientos: autoNumeroAsientos ?? this.autoNumeroAsientos,
        autoTipoNombre: autoTipoNombre ?? this.autoTipoNombre,
        factorFormaId: factorFormaId ?? this.factorFormaId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoId': autoId,
      'tipoId': tipoId,
      'tipoNombre': tipoNombre,
      'marcaId': marcaId,
      'marcaNombre': marcaNombre,
      'modeloId': modeloId,
      'modeloNombre': modeloNombre,
      'colorId': colorId,
      'color': color?.toMap(),
      'colorNombre': colorNombre,
      'autoAno': autoAno,
      'autoDescripcion': autoDescripcion,
      'beneficiarioId': beneficiarioId,
      'beneficiario': beneficiario?.toMap(),
      'beneficiarioNombre': beneficiarioNombre,
      'autoFecha': autoFecha,
      'autoEstatus': autoEstatus,
      'paisId': paisId,
      'paisNombre': paisNombre,
      'provinciaId': provinciaId,
      'provinciaNombre': provinciaNombre,
      'ciudadId': ciudadId,
      'ciudadNombre': ciudadNombre,
      'autoDireccion': autoDireccion,
      'autoCoorX': autoCoorX,
      'autoCoorY': autoCoorY,
      'precio': precio,
      'seguroId': seguroId,
      'seguroNombre': seguroNombre,
      'autoTransmision': autoTransmision,
      'autoDondeSea': autoDondeSea,
      'autoCondiciones': autoCondiciones,
      'autoKmIncluido': autoKmIncluido,
      'imagen': imagen,
      'urlImagenPrincipal': urlImagenPrincipal,
      'imagenesColeccion': imagenesColeccion?.map((x) => x.toMap()).toList(),
      'valoracion': valoracion,
      'valoraciones': valoraciones?.map((x) => x.toMap()).toList(),
      'svgMarca': svgMarca,
      'precioViejo': precioViejo,
      'autoNumeroViajes': autoNumeroViajes,
      'hexColor': hexColor,
      'imagenesTransparentes':
          imagenesTransparentes?.map((x) => x.toMap()).toList(),
      'autoNumeroPersonas': autoNumeroPersonas,
      'autoNumeroPuertas': autoNumeroPuertas,
      'autoNumeroAsientos': autoNumeroAsientos,
      'autoTipoNombre': autoTipoNombre,
      'factorFormaId': factorFormaId,
      'marca': marca?.toMap(),
      'modelo': modelo?.toMap(),
      'factorFormaNombre': factorFormaNombre,
      'modeloVersionId': modeloVersionId,
      'combustibleId': combustibleId,
      'transmisionId': transmisionId
    };
  }

  String toJson() => json.encode(toMap());

  factory Auto.fromJson(String source) =>
      Auto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Auto(autoId: $autoId, tipoId: $tipoId, tipoNombre: $tipoNombre, marcaId: $marcaId, marcaNombre: $marcaNombre, modeloId: $modeloId, modeloNombre: $modeloNombre, colorId: $colorId, colorNombre: $colorNombre, autoAno: $autoAno, autoDescripcion: $autoDescripcion, beneficiarioId: $beneficiarioId, beneficiarioNombre: $beneficiarioNombre, autoFecha: $autoFecha, autoEstatus: $autoEstatus, paisId: $paisId, paisNombre: $paisNombre, provinciaId: $provinciaId, provinciaNombre: $provinciaNombre, ciudadId: $ciudadId, ciudadNombre: $ciudadNombre, autoDireccion: $autoDireccion, autoCoorX: $autoCoorX, autoCoorY: $autoCoorY, precioId: $precioId, precioPlataforma: $precioPlataforma, seguroId: $seguroId, seguroNombre: $seguroNombre, autoTransmision: $autoTransmision, autoDondeSea: $autoDondeSea, autoCondiciones: $autoCondiciones, autoKmIncluido: $autoKmIncluido, imagen: $imagen, urlImagenPrincipal: $urlImagenPrincipal, imagenesColeccion: $imagenesColeccion, valoracion: $valoracion, valoraciones: $valoraciones, svgMarca: $svgMarca, precioViejo: $precioViejo, autoNumeroViajes: $autoNumeroViajes, hexColor: $hexColor, imagenesTransparentesBase64: $imagenesTransparentes, autoNumeroPersonas: $autoNumeroPersonas, autoNumeroPuertas: $autoNumeroPuertas, autoNumeroAsientos: $autoNumeroAsientos, autoTipoNombre: $autoTipoNombre, factorFormaId: $factorFormaId)';
  }

  @override
  bool operator ==(covariant Auto other) {
    if (identical(this, other)) return true;

    return other.autoId == autoId &&
        other.tipoId == tipoId &&
        other.tipoNombre == tipoNombre &&
        other.marcaId == marcaId &&
        other.marcaNombre == marcaNombre &&
        other.modeloId == modeloId &&
        other.modeloNombre == modeloNombre &&
        other.colorId == colorId &&
        other.colorNombre == colorNombre &&
        other.autoAno == autoAno &&
        other.autoDescripcion == autoDescripcion &&
        other.beneficiarioId == beneficiarioId &&
        other.beneficiarioNombre == beneficiarioNombre &&
        other.autoFecha == autoFecha &&
        other.autoEstatus == autoEstatus &&
        other.paisId == paisId &&
        other.paisNombre == paisNombre &&
        other.provinciaId == provinciaId &&
        other.provinciaNombre == provinciaNombre &&
        other.ciudadId == ciudadId &&
        other.ciudadNombre == ciudadNombre &&
        other.autoDireccion == autoDireccion &&
        other.autoCoorX == autoCoorX &&
        other.autoCoorY == autoCoorY &&
        other.precioId == precioId &&
        other.precioPlataforma == precioPlataforma &&
        other.seguroId == seguroId &&
        other.seguroNombre == seguroNombre &&
        other.autoTransmision == autoTransmision &&
        other.autoDondeSea == autoDondeSea &&
        other.autoCondiciones == autoCondiciones &&
        other.autoKmIncluido == autoKmIncluido &&
        other.imagen == imagen &&
        other.urlImagenPrincipal == urlImagenPrincipal &&
        listEquals(other.imagenesColeccion, imagenesColeccion) &&
        other.valoracion == valoracion &&
        listEquals(other.valoraciones, valoraciones) &&
        other.svgMarca == svgMarca &&
        other.precioViejo == precioViejo &&
        other.autoNumeroViajes == autoNumeroViajes &&
        other.hexColor == hexColor &&
        listEquals(other.imagenesTransparentes, imagenesTransparentes) &&
        other.autoNumeroPersonas == autoNumeroPersonas &&
        other.autoNumeroPuertas == autoNumeroPuertas &&
        other.autoNumeroAsientos == autoNumeroAsientos &&
        other.autoTipoNombre == autoTipoNombre &&
        other.factorFormaId == factorFormaId;
  }

  @override
  int get hashCode {
    return autoId.hashCode ^
        tipoId.hashCode ^
        tipoNombre.hashCode ^
        marcaId.hashCode ^
        marcaNombre.hashCode ^
        modeloId.hashCode ^
        modeloNombre.hashCode ^
        colorId.hashCode ^
        colorNombre.hashCode ^
        autoAno.hashCode ^
        autoDescripcion.hashCode ^
        beneficiarioId.hashCode ^
        beneficiarioNombre.hashCode ^
        autoFecha.hashCode ^
        autoEstatus.hashCode ^
        paisId.hashCode ^
        paisNombre.hashCode ^
        provinciaId.hashCode ^
        provinciaNombre.hashCode ^
        ciudadId.hashCode ^
        ciudadNombre.hashCode ^
        autoDireccion.hashCode ^
        autoCoorX.hashCode ^
        autoCoorY.hashCode ^
        precioId.hashCode ^
        precioPlataforma.hashCode ^
        seguroId.hashCode ^
        seguroNombre.hashCode ^
        autoTransmision.hashCode ^
        autoDondeSea.hashCode ^
        autoCondiciones.hashCode ^
        autoKmIncluido.hashCode ^
        imagen.hashCode ^
        urlImagenPrincipal.hashCode ^
        imagenesColeccion.hashCode ^
        valoracion.hashCode ^
        valoraciones.hashCode ^
        svgMarca.hashCode ^
        precioViejo.hashCode ^
        autoNumeroViajes.hashCode ^
        hexColor.hashCode ^
        imagenesTransparentes.hashCode ^
        autoNumeroPersonas.hashCode ^
        autoNumeroPuertas.hashCode ^
        autoNumeroAsientos.hashCode ^
        autoTipoNombre.hashCode ^
        factorFormaId.hashCode;
  }

  factory Auto.fromMap(Map<String, dynamic> map) {
    return Auto(
        autoId: map['autoId'] != null ? map['autoId'] as int : null,
        tipoId: map['tipoId'] != null ? map['tipoId'] as int : null,
        tipoAuto: map['tipo'] != null ? TipoAuto.fromMap(map['tipo']) : null,
        tipoNombre:
            map['tipoNombre'] != null ? map['tipoNombre'] as String : null,
        marcaId: map['marcaId'] != null ? map['marcaId'] as int : null,
        modeloId: map['modeloId'] != null ? map['modeloId'] as int : null,
        colorId: map['colorId'] != null ? map['colorId'] as int : null,
        color: map['color'] != null ? MyColor.fromMap(map['color']) : null,
        autoAno: map['autoAno'] != null ? map['autoAno'] as int : null,
        autoDescripcion: map['autoDescripcion'] != null
            ? map['autoDescripcion'] as String
            : null,
        beneficiarioId:
            map['beneficiarioId'] != null ? map['beneficiarioId'] as int : null,
        beneficiario: map['beneficiario'] != null
            ? Beneficiario.fromMap(map['beneficiario'])
            : null,
        autoFecha: map['autoFecha'] != null ? map['autoFecha'] as String : null,
        autoEstatus:
            map['autoEstatus'] != null ? map['autoEstatus'] as int : null,
        paisId: map['paisId'] != null ? map['paisId'] as int : null,
        provinciaId:
            map['provinciaId'] != null ? map['provinciaId'] as int : null,
        ciudadId: map['ciudadId'] != null ? map['ciudadId'] as int : null,
        autoCoorX: double.parse(map['autoCoorX']),
        autoCoorY: double.parse(map['autoCoorY']),
        precio: map['precio'] != null ? double.parse(map['precio']) : null,
        seguroId: map['seguroId'] != null ? map['seguroId'] as int : null,
        autoCondiciones: map['autoCondiciones'] != null
            ? map['autoCondiciones'] as String
            : null,
        autoKmIncluido: int.parse(map['autoKmIncluido']),
        imagenesColeccion: (map['imagenes'] as List)
            .map((e) => ImagenModel.fromMap(e))
            .toList()
            .cast<ImagenModel>(),
        valoracion: map['valoracion'] != null
            ? double.parse(map['valoracion']).toPrecision(1)
            : null,
        valoraciones: map['valoraciones'] != null
            ? (map['valoraciones'] as List)
                .map((e) => Valoracion.fromMap(e))
                .toList()
                .reversed
                .toList()
                .cast<Valoracion>()
            : null,
        precioViejo:
            map['precioViejo'] != null ? map['precioViejo'] as num : null,
        autoNumeroViajes: map['autoNumeroViajes'],
        autoNumeroPersonas: map['autoNumeroPersonas'],
        autoNumeroPuertas: map['autoNumeroPuertas'],
        autoNumeroAsientos: map['autoNumeroAsientos'],
        marca: map['marca'] != null ? Marca.fromMap(map['marca']) : null,
        modelo: map['modelo'] != null ? Modelo.fromMap(map['modelo']) : null,
        provincia: map['provincia'] != null
            ? Provincia.fromJson(map['provincia'])
            : null,
        ciudad: map['ciudad'] != null ? Ciudad.fromMap(map['ciudad']) : null,
        transmisionId:
            map['transmisionId'] != null ? map['transmisionId'] as int : null,
        transmision: map['transmision'] != null
            ? Transmision.fromMap(map['transmision'])
            : null,
        autosMeGustas: map['autosMeGustas'] != null
            ? (map['autosMeGustas'] as List)
                .map((e) => AutoMegustaModel.fromMap(e))
                .toList()
                .cast<AutoMegustaModel>()
            : null,
        modeloVersionId: map['modeloVersionId'],
        modeloVersion: map['modeloVersion'] != null
            ? ModeloVersion.fromMap(map['modeloVersion'])
            : null,
        combustibleId: map['combustibleId'],
        combustible: map['combustible'] != null
            ? Combustible.fromMap(map['combustible'])
            : null);
  }
}

class ImagenesColeccion {
  String? urlImagen;
  bool? principal;

  ImagenesColeccion({
    this.urlImagen,
    this.principal,
  });

  ImagenesColeccion.fromJson(Map<String, dynamic> json) {
    urlImagen = json['urlImagen'];
    principal = json['principal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['urlImagen'] = urlImagen;
    data['principal'] = principal;
    return data;
  }

  ImagenesColeccion copyWith({
    String? urlImagen,
    bool? principal,
  }) {
    return ImagenesColeccion(
      urlImagen: urlImagen ?? this.urlImagen,
      principal: principal ?? this.principal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'urlImagen': urlImagen,
      'principal': principal,
    };
  }

  factory ImagenesColeccion.fromMap(Map<String, dynamic> map) {
    return ImagenesColeccion(
      urlImagen: map['urlImagen'] != null ? map['urlImagen'] as String : null,
      principal: map['principal'] != null ? map['principal'] as bool : null,
    );
  }

  @override
  String toString() =>
      'ImagenesColeccion(urlImagen: $urlImagen, principal: $principal)';

  @override
  bool operator ==(covariant ImagenesColeccion other) {
    if (identical(this, other)) return true;

    return other.urlImagen == urlImagen && other.principal == principal;
  }

  @override
  int get hashCode => urlImagen.hashCode ^ principal.hashCode;
}

class Valoracion {
  int? valorId;
  int? reservaId;
  num? valorPuntuacion;
  int? autoId;
  String? valorComentario;
  String? valorFecha;
  int? usuarioId;
  String? autorNombre;
  String? autorAvatarImage;
  Usuario? usuario;
  Valoracion(
      {this.valorId,
      this.reservaId,
      this.valorPuntuacion,
      this.autoId,
      this.valorComentario,
      this.valorFecha,
      this.usuarioId,
      this.autorNombre,
      this.autorAvatarImage,
      this.usuario});

  Future<Valoracion?> create() async {
    try {
      var res = await rentApi.post('/valoraciones/crear', data: toMap());
      if (res.statusCode == 200) {
        return Valoracion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Valoracion copyWith({
    int? valorId,
    int? reservaId,
    num? valorPuntuacion,
    int? autoId,
    String? valorComentario,
    String? valorFecha,
    int? usuarioId,
    String? autorNombre,
    String? autorAvatarImage,
  }) {
    return Valoracion(
      valorId: valorId ?? this.valorId,
      reservaId: reservaId ?? this.reservaId,
      valorPuntuacion: valorPuntuacion ?? this.valorPuntuacion,
      autoId: autoId ?? this.autoId,
      valorComentario: valorComentario ?? this.valorComentario,
      valorFecha: valorFecha ?? this.valorFecha,
      usuarioId: usuarioId ?? this.usuarioId,
      autorNombre: autorNombre ?? this.autorNombre,
      autorAvatarImage: autorAvatarImage ?? this.autorAvatarImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'valorId': valorId,
      'reservaId': reservaId,
      'valorPuntuacion': valorPuntuacion,
      'autoId': autoId,
      'valorComentario': valorComentario,
      'valorFecha': valorFecha,
      'usuarioId': usuarioId,
      'autorNombre': autorNombre,
      'autorAvatarImage': autorAvatarImage,
      'usuario': usuario?.toMap()
    };
  }

  factory Valoracion.fromMap(Map<String, dynamic> map) {
    return Valoracion(
        valorId: map['valorId'] != null ? map['valorId'] as int : null,
        valorPuntuacion: map['valorPuntuacion'] != null
            ? double.parse(map['valorPuntuacion'])
            : null,
        autoId: map['autoId'] != null ? map['autoId'] as int : null,
        valorComentario: map['valorComentario'] != null
            ? map['valorComentario'] as String
            : null,
        valorFecha:
            map['valorFecha'] != null ? map['valorFecha'] as String : null,
        usuarioId: map['autorId'] != null ? map['autorId'] as int : null,
        usuario:
            map['usuario'] != null ? Usuario.fromMap(map['usuario']) : null);
  }

  String toJson() => json.encode(toMap());

  factory Valoracion.fromJson(String source) =>
      Valoracion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Valoracion(valorId: $valorId, reservaId: $reservaId, valorPuntuacion: $valorPuntuacion, autoId: $autoId, valorComentario: $valorComentario, valorFecha: $valorFecha, usuarioId: $usuarioId, autorNombre: $autorNombre, autorAvatarImage: $autorAvatarImage)';
  }

  @override
  bool operator ==(covariant Valoracion other) {
    if (identical(this, other)) return true;

    return other.valorId == valorId &&
        other.reservaId == reservaId &&
        other.valorPuntuacion == valorPuntuacion &&
        other.autoId == autoId &&
        other.valorComentario == valorComentario &&
        other.valorFecha == valorFecha &&
        other.usuarioId == usuarioId &&
        other.autorNombre == autorNombre &&
        other.autorAvatarImage == autorAvatarImage;
  }

  @override
  int get hashCode {
    return valorId.hashCode ^
        reservaId.hashCode ^
        valorPuntuacion.hashCode ^
        autoId.hashCode ^
        valorComentario.hashCode ^
        valorFecha.hashCode ^
        usuarioId.hashCode ^
        autorNombre.hashCode ^
        autorAvatarImage.hashCode;
  }
}

class Transmision {
  int? transmisionId;
  String? transmisionNombre;
  DateTime? fhCreacion;
  Transmision({
    this.transmisionId,
    this.transmisionNombre,
    this.fhCreacion,
  });

  Transmision copyWith({
    int? transmisionId,
    String? transmisionNombre,
    DateTime? fhCreacion,
  }) {
    return Transmision(
      transmisionId: transmisionId ?? this.transmisionId,
      transmisionNombre: transmisionNombre ?? this.transmisionNombre,
      fhCreacion: fhCreacion ?? this.fhCreacion,
    );
  }

  static Future<List<Transmision>> get() async {
    try {
      var res = await rentApi.get('/transmisiones/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Transmision.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create() async {
    try {
      await rentApi.post('/transmisiones/crear',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update() async {
    try {
      await rentApi.put('/transmisiones/modificar/$transmisionId',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transmisionId': transmisionId,
      'transmisionNombre': transmisionNombre,
      'fhCreacion': fhCreacion?.toIso8601String(),
    };
  }

  factory Transmision.fromMap(Map<String, dynamic> map) {
    return Transmision(
      transmisionId:
          map['transmisionId'] != null ? map['transmisionId'] as int : null,
      transmisionNombre: map['transmisionNombre'] != null
          ? map['transmisionNombre'] as String
          : null,
      fhCreacion:
          map['fhCreacion'] != null ? DateTime.parse(map['fhCreacion']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transmision.fromJson(String source) =>
      Transmision.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Transmision(transmisionId: $transmisionId, transmisionNombre: $transmisionNombre, fhCreacion: $fhCreacion)';

  @override
  bool operator ==(covariant Transmision other) {
    if (identical(this, other)) return true;

    return other.transmisionId == transmisionId &&
        other.transmisionNombre == transmisionNombre &&
        other.fhCreacion == fhCreacion;
  }

  @override
  int get hashCode =>
      transmisionId.hashCode ^ transmisionNombre.hashCode ^ fhCreacion.hashCode;
}
