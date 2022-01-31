import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  ///apretamos ctrl + . y nos crea los siguientes 4 metodos

  ///sobreescribo el metodo searchFieldLabel de la clase SearchDelegate para que en el
  ///buscador en vez de Search diga Buscar Pelicula
  ///Para ver como se filtarn las peliculas debemos ir a la api de MovieDataBase a la parte de SEARCH GET MOVIES
  ///Ahi con nuestra api key y pasandole una query de referencia obtenemos el endpoint. Luego en quicktipe convertimos la peticion en
  ///una clase de Dart (mapeo).
  @override
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    ///el metodo buildactions se usa para colocar botones al costado del buscador
    return [
      ///este boton es para borrar lo que escribimos en el buscador. Cuando lo
      ///presionamos entonces el query lo dejamos vacio.
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    /// En este metodo podemos poner un boton para regresar a la pantalla anterior. Uso el metodo close de
    /// la clase SearchDelegate para cerrar el buscador
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('BuildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ///Esto se dispara cada vez que la persona toca una tecla en el buscador. Sin embargo el StreamBuilder se va a
    ///dibujar solo cuando el moviesProvider.suggestionsStream emita un valor.
    if (query.isEmpty) {
      return Container(
        child: const Center(
          child: Icon(
            Icons.movie_creation_outlined,
            color: Colors.black12,
            size: 150,
          ),
        ),
      );
    }
    print('http request');

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    ///esto se dispara cada vez que escribimos una letra en el buscador

    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: const Center(
              child: Icon(
                Icons.movie_creation_outlined,
                color: Colors.black12,
                size: 150,
              ),
            ),
          );
        }
        final movies = snapshot.data!;
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) {
              return _MovieItem(movie: movies[index]);
            });
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    movie.heroId =
        'search-${movie.id}'; //cada heroId debe ser diferente ya que se permite un heroId por pantalla
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.png'),
          image: NetworkImage(movie.fullPosterImg),
          width: 70,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
