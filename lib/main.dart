import 'package:flutter/material.dart';
import 'package:peliculasapp/pages/pages.dart';
import 'package:peliculasapp/providers/movies_providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

///defino arriba de todo la clase AppState para poder acceder a la clase movieProvider
///desde cualquier lugar de mi aplicacion
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///uso multiprovider para definir muchos provider. En este caso uso solo un provider
    return MultiProvider(
      child: const MyApp(),
      providers: [
        ///poniendo lazy en false obligamos a que se inicialice el constructor cuando se ejecuta la aplicacion
        ChangeNotifierProvider(
            lazy: false, create: (context) => MoviesProvider())
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas ',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => const HomeScreen(),
        'detail': (BuildContext context) => const DetailScreen()
      },
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: Colors.indigo)),
    );
  }
}
