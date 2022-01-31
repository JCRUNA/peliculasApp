import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  const CastingCards({Key? key, required this.movieId}) : super(key: key);
  final int movieId;

  @override
  Widget build(BuildContext context) {
    ///llamo a mi instancia de movieprovider asi puedo utilizarla en el
    ///FutureBuilder
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          //si el future no trae datos
          return Container(
            height: 180,
            child: const CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
              itemCount: cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (cast.isEmpty) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 110,
                      height: 100,
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const FadeInImage(
                              fit: BoxFit.cover,
                              height: 130,
                              placeholder:
                                  AssetImage('assets/InfinityLoading.gif'),
                              image: AssetImage('assets/InfinityLoading.gif')),
                        )
                      ]));
                } else {
                  return CastCards(actor: cast[index]);
                }
              }),
        );
      },
    );
  }
}

class CastCards extends StatelessWidget {
  const CastCards({Key? key, required this.actor}) : super(key: key);
  final Cast actor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                fit: BoxFit.cover,
                height: 130,
                placeholder: AssetImage('assets/InfinityLoading.gif'),
                image: NetworkImage(actor.fullProfilePath)),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.originalName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
