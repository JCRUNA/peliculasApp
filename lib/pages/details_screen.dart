import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///la variable movie almacenara el string de la instancia del movie que seleccionemos
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(

        ///el customScrollview es similar al singleChildScrollView. Sin embargo nos permite
        ///trabajar con sliver. Los slivers son widgets que tienen un comportamiento diferente cuando
        ///se hace scroll en el padre.
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(movie: movie),

        ///para colocar la imagen y al lado la descripcion defino el widget
        ///SliverList
        SliverList(
            delegate: SliverChildListDelegate([
          _PosterAndTitle(movie: movie),
          _Overview(movie: movie),
          CastingCards(movieId: movie.id)
        ]))
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,

      ///flexibleSpace es una propiedad de los sliver que nos permite mostrar el titulo del sliverAppbar
      ///centrar el titulo y pasarle cualquier widget a su child
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.black45,
            child: Text(
              movie.originalTitle,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            )),
        background: FadeInImage(
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/InfinityLoading.gif'),
            image: NetworkImage(movie.fullBackDropPath)),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    height: 150,
                    width: 110,
                    fit: BoxFit.contain,
                    placeholder: const AssetImage('assets/no-image.png'),
                    image: NetworkImage(movie.fullPosterImg)),
              ),
            ),

            ///dejo un espacio de 20 px ya que luego va el widget column con el detalle de la peli
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width - 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    movie.originalTitle,
                    style: textTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_border_outlined,
                        size: 20,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        movie.voteAverage.toString(),
                        style: textTheme.caption,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
