import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculasapp/helpers/debouncer.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/models/search_movies_response.dart';

///la clase Provider debe extender de la clase ChangeNotifier
class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '3d022dec7b66d7d1a81417dafe2f9a90';
  final String _language = 'es-Es';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovie = [];
  int _popularPage = 0;

  ///creo listado vacio donde almacenare las pelis
  ///creo listado vacio de peliculas populares

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  ///esto emite valores en este caso lista de movies.
  Stream<List<Movie>> get suggestionsStream =>
      _suggestionsStreamController.stream;

  MoviesProvider() {
    // ignore: avoid_print
    print('Movies Provider Inicializado');

    ///cuando se crea el constructor llamo al metodo
    getOnDisplayMovie();
    getPopularMovies();
  }

  ///este metodo lo hago para optimizar el codigo ya que tanto en el
  ///metodo getOnDisplayMovie como en getPopularMovies tengo que hacer las peticiones http
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url); //devuelve la respuesta
    return response.body;
  }

  getOnDisplayMovie() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlaying = NowPlaying.fromJson(jsonData);

    onDisplayMovie = nowPlaying.results;

    ///agregamos las peliculas
    ///debemos llamar al NotifierListener para volver a dibujar los widget que se modificaron
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    ///el popularmovie lo desestructuro ya que lo voy a volver a llamar cambiando el page, y por lo tanto
    ///quiero mantener todas las peliculas

    popularMovie = [...popularMovie, ...popularResponse.results];
    notifyListeners();
  }

// metodo para hacer la peticion http y obtener la lista de actores
  Future<List<Cast>> getMovieCast(int movieId) async {
    // TO DO: REVISAR MAPA
    ///Cada vez que vamos a la pagina detailsScreen se vuelve a disparar esta peticion HTTP.
    ///Pero este es un comportamiento que no queremos ya que deberia dispararse una sola vez cuando y despues
    ///almacenarse en memoria para no malgastar recursos. Para eso hacemos uso del metodo containsKey y le pasemos el id de la pelicula

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    // ignore: avoid_print
    print('pidiendo info al servidor');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  ///Hago la peticion https y luego el mapeo creando una instancia de SearchResponse (es el archivo search_movies_Response.dart)
  ///luego llamo a la propiedad results de la instancia search response que es una lista de movies. Eso es lo que retorno.
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url); //devuelve la respuesta
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('tenemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionsStreamController.add(
          results); //necesimoa emitir un valor. Con add agregamos el evento que ocurrio.
    };

    ///cada vez que pase este tiempo entonces voy a mandar el valor del debouncer que recibo como argumento searchTerm. Una vez que
    ///pasa ese tiempo entonces el valor del debouncer va a emitirse en debouncer.onvalue
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    ///cuando se resulva llamo al timer.cancel
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
