import 'package:flutter/material.dart';
import 'package:peliculasapp/providers/movies_providers.dart';
import 'package:peliculasapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:peliculasapp/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Necesito que vaya al arbol de widget (con of) y me encuentre la primer instancia
    ///de moviesProvider. Si no encuentra una, entonces crea una nueva.
    ///Esta es la magia del Provider ya que desde cualquier parte de la aplicacion, en este caso desde HomeScreen,
    ///busco y traigo la instancia de MoviesProvider
    ///Ponemos listen en true
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Peliculas en Cine'),
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          //tarjetas de peliculas principales
          CardSwiper(
            movies: moviesProvider.onDisplayMovie,
          ),
          //slider de peliculas
          MovieSlider(
            movies: moviesProvider.popularMovie,
            title: 'Populares',
            onNextPage: () => moviesProvider.getPopularMovies(),
          ),
        ]),
      ),
    );
  }
}
