import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_modelo.dart';


import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    

      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppbar(pelicula),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10.0),
                  _posterTitulo(pelicula, context),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _footerCast (pelicula),
                ]
              ),
            )
          ],
         )
        );
      }

     

    Widget _crearAppbar(Pelicula pelicula) {
        return 
        SliverAppBar(
          elevation: 2.0,
          backgroundColor: Colors.indigoAccent,
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              pelicula.title,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),

            background: FadeInImage(
              placeholder: AssetImage('assets/img/loading.gif'), 
              image: NetworkImage(pelicula.getBackgroundImg()),
              fadeInDuration: Duration(milliseconds: 150),
              fit: BoxFit.cover
            ),
          ),
        );
      }

    Widget _posterTitulo (Pelicula pelicula, BuildContext context ) {
      return
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Hero(
                tag: pelicula.uniqueId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    image: NetworkImage(pelicula.getPostImg()),
                    height: 150.0
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis,),
                    Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1,overflow: TextOverflow.ellipsis),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star_border),
                        Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _footerCast(Pelicula pelicula) {
    
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getActores(pelicula.id.toString(), 2),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) return _crearActoresPageView(snapshot.data);
        else return Center( child: CircularProgressIndicator());
      });
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: .275,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _actorPin (actores[i]);
        },
      ),
    );
  }


  Widget _actorPin (Actor actor){

    String imagen = (actor.gender == 1) ?  'no-user-saylor' : 'no-user-goku';

    return Container (
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getSelfie()),
              placeholder: AssetImage('assets/img/$imagen.jpg'),
              height: 145.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4.0),
          Text(actor.name, overflow: TextOverflow.ellipsis)
        ],
      )
    );
  }


}

