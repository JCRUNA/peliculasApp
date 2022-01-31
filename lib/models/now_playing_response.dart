///esta clase sirve para mapear la respuesta de la peticion HTTPS. Para hacer esto usamos
///la herramienta quicktipe.io
///

// To parse this JSON data, do
//
//     final nowPlaying = nowPlayingFromMap(jsonString);

import 'dart:convert';

import 'package:peliculasapp/models/models.dart';

class NowPlaying {
  NowPlaying({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  /// recibe la respuesta str y la convierte en un mapa a traves del metodo decode
  factory NowPlaying.fromJson(String str) =>
      NowPlaying.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());  Siver para la peticion post
  ///recibe un mapa y asigna cada valor a su respectiva propieda de la clae NowPlaying
  factory NowPlaying.fromMap(Map<String, dynamic> json) => NowPlaying(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],

        ///a la propiedad results se le asigna una lista de movies
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  ///Se utiliza para peticion POST
  // Map<String, dynamic> toMap() => {
  //     "dates": dates.toMap(),
  //     "page": page,
  //     "results": List<dynamic>.from(results.map((x) => x.toMap())),
  //     "total_pages": totalPages,
  //     "total_results": totalResults,
  // };
}

class Dates {
  Dates({
    required this.maximum,
    required this.minimum,
  });

  DateTime maximum;
  DateTime minimum;

  factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

  ///lo uso para convertir el map a json para el metodo POST
  // String toJson() => json.encode(toMap());

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  ///LO USO PARA LA PETICION POST
  // Map<String, dynamic> toMap() => {
  //       "maximum":
  //           "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
  //       "minimum":
  //           "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
  //     };
}
