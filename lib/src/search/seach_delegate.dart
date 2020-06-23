

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSeach extends SearchDelegate {

  String seleccion;
  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    //Acciones del AopBar como cancelar o borrar la  busqueda

    return [
      IconButton(icon: Icon(
        Icons.clear), 
        onPressed: () { query = ''; }
      ),
      
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del Appbar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return

    
    Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.pink,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    if (query.isEmpty)
    return Container();

    return FutureBuilder(
      future: peliculasProvider.buscarMovie('movie', 3, query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              
            ],
          );
        } else{
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );

    /*final busquedaSugerida = (query.isEmpty) ? null : null;


        return ListView.builder(

          itemCount: null,
          itemBuilder: (context, i ) {
            return ListTile(
              leading: Icon(Icons.movie),
              title: Text(''),
              onTap: () {
                seleccion = busquedaSugerida[i];
                showResults(context);
              },
            );
          }
        );*/
  }

}