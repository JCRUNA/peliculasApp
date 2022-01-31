import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider(
      {Key? key, required this.movies, this.title, required this.onNextPage})
      : super(key: key);
  final List<Movie> movies;
  final String? title;
  final Function
      onNextPage; //defino esta funcion que se llama cuando llegamos al final del scroll

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  ///para trabajar con el scroll tuve que convertir la clase MovieSlider
  ///de Stateless a Staful

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ///creo el listener para el controller
    scrollController.addListener(() {
      ///Lo que queremos hacer es que cuando lleguemos al final de la lista de peliculas
      ///populares entonces hagamos una nueva peticion HTTP para que nos traiga nuevas
      ///peliculas.
      ///Pero como hacemos para saber cuando llegamos al final de la lista?
      ///Para eso es que usamos el scrollcontroler y accedemos a los ultimos pixeles con
      ///maxScrollExtent y eso lo comparamos con los valores de los pixeles actuales

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        widget.onNextPage();
        //TO DO: HACER PETICIONHTTP

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                ///agrego el controller definido arriba
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (BuildContext context, int index) => _MoviePoster(
                  movie: widget.movies[index],
                  heroid: '${widget.title}-$index-${widget.movies[index].id}',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({Key? key, required this.movie, required this.heroid})
      : super(key: key);
  final Movie movie;
  final String heroid;

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroid;
    if (movie == null) {
      return Container(
        width: double.infinity,
        height: 100,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 190,
      width: 130,
      child: Column(
        children: [
          ///agrego el widget GestureDetector ya que tiene el metodo onTap que lo uso para navegar
          ///a otra pagina.
          ///En el metodo PushNamed del Navigator ademas de pasarle el context y el nombre de la ruta,
          ///tambien el paso unos argumentes que por ahora es solo un texto. Pero este campo arguments
          ///me va a permitir pasar una instancia de la pelicula que seleccione a la pantalla detailsScreen
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'detail',
                arguments: movie), //le paso la clase movie como argumento
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/InfinityLoading.gif'),
                    image: NetworkImage(movie.fullPosterImg)),
              ),
            ),
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
