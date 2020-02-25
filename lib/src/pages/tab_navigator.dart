import 'package:flutter/material.dart';
import 'package:play/src/models/pelicula_model.dart';
import 'package:play/src/pages/pelicula_page.dart';
import 'package:play/src/utils/bottom_navigation.dart';
import 'package:play/src/pages/inicio_page.dart';
import 'package:play/src/pages/pelicula_detalle_page.dart';
import 'package:play/src/pages/perfil_page.dart';
import 'package:play/src/pages/series_page.dart';

class TabNavigatorRoutes {
  static const String inicio    = '/';
  static const String peliculas = '/peliculas';
  static const String detalle   = '/detalle';
  static const String series    = '/series';
  static const String perfil    = '/perfil';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.pelicula});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final Pelicula pelicula;

  void _push(BuildContext context, Pelicula pelicula) {
    var routeBuilders = _routeBuilders(context, pelicula);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.peliculas](context),
      ),
    );
  }

  /* void _pushPeliculas(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.peliculas](context),
      ),
    );
  } */

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, Pelicula pelicula) {
    if(tabItem == TabItem.inicio){
      return {
        TabNavigatorRoutes.inicio: (context) => InicioPage()
      };
    }else if(tabItem == TabItem.peliculas) {
      return {
        TabNavigatorRoutes.inicio: (context) => PeliculaPage(
          onPush: (pelicula) => _push(context, pelicula),
        ),
        TabNavigatorRoutes.peliculas: (context) => PeliculaDetalle(
          pelicula: pelicula,
          onPush: (pelicula) => _push(context, pelicula),
        )
      };
    }else if(tabItem == TabItem.series) {
      return {
        TabNavigatorRoutes.inicio: (context) => SeriesPage()
      };
    }else {
      return {
        TabNavigatorRoutes.inicio: (context) => PerfilPage()
      };
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context, pelicula);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.inicio,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}