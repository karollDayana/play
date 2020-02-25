import 'package:flutter/material.dart';
import 'package:play/src/models/actores_model.dart';
import 'package:play/src/models/pelicula_model.dart';
import 'package:play/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  final Pelicula pelicula;
  final ValueChanged<Pelicula> onPush;
  final peliculaProvider = PeliculasProvider();

  PeliculaDetalle({this.pelicula, this.onPush});

  @override
  Widget build(BuildContext context) {

    
    // final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 15.0),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _titulo(context, 'Reparto'),
                _crearCasting(pelicula),
                _titulo(context, 'Otras personas también buscan'),
                _peliculasRelacionadas(pelicula),
              ]
            )
          )
        ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.brown[400],
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(
            color: Colors.white, 
            fontSize: 16.0 
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      height: 250.0,
      padding: EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _titulo(BuildContext context, String titulo) {
    return Container(
      padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
      child: Text(titulo, style: Theme.of(context).textTheme.subtitle)
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        
        if(snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i])
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 170.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _peliculasRelacionadas(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getPeliculasRelacionadas(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData) {
          return _peliculasRelacionadasPageView(snapshot.data);
        }else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }

  Widget _peliculasRelacionadasPageView(List<Pelicula> peliculas ) {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _peliculasRelacionadasTarjeta(context, peliculas[i])
      ),
    );
  }

  Widget _peliculasRelacionadasTarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-prelacionada';
    return Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => onPush(pelicula),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  height: 170.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}