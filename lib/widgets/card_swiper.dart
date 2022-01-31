import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    ///Si yo quiero que el cardSwiper tenga un alto del 50% de la pantalla como lo hago?
    ///Uso el widget MediaQuery que nos facilita la informacion de las dimensiones y orientacion
    ///de la pantalla.
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return Container(
        width: double.infinity,
        height: size.height * 0.6,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 0),
      width: size.width * 0.8,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.7,
        itemHeight: size.height * 0.8,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];

          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'detail', arguments: movie),

            ///para hacer una transicion de la pantalla homescreen a detailsscreen usamos el widget
            ///Hero que necesita que le pasemos un child y un tag que es un objeto (puede ser cualquier cosa) que identique unicamente al widget hero ya que hay uno por pantalla.
            ///Pero como en homescreen tenemos un cardswiper y un movieslider y puede ocurrir que el movie.id, es decir, la pelicula este tanto en el carrusel del cardswiper como
            ///en el movieslider entonces no estariamos identificando univocamente al widget hero.
            ///Como solucion creamos una propiedad en la clase movie llamada heroId que identfique a cada ClipRRect
            ///Podemos pasarle el movie.id q es unico. Tenemos que hacer lo mismo en la pagina detailscreen en el widget CliRRect del widget PosterandTitle ya que de
            ///esta manera queda unida la transicion entre las pantallas
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/no-image.png'),
                    image: NetworkImage(movie.fullPosterImg)),
              ),
            ),
          );
        },
      ),
    );
  }
}
