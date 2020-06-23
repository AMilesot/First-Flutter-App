import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextPage;

  MovieHorizontal({@required this.peliculas, @required this.nextPage});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: .275
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    
    _pageController.addListener(() { 
      if(_pageController.position.pixels >= _pageController.position.pixels - 250){
        nextPage('popular', 1);
      }
    });

    return Container(
      height: _screenSize.height * .2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) =>_tarjeta(context, peliculas[i])
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {

    final _screenSize = MediaQuery.of(context).size;

    pelicula.uniqueId = '${pelicula.id}-poster';
    
    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child:// ListView(
        Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(pelicula.getPostImg()),
                  fit: BoxFit.cover,
                  height: _screenSize.height * .1774,
                  //height: 144.0,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Text(pelicula.title, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption)
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle',arguments: pelicula);
        }
      );
  }

  List<Widget> _tarjetas (BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: ListView(
        //Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage(pelicula.getPostImg()),
                fit: BoxFit.cover,
                height: _screenSize.height * .1774,
                //height: 144.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(pelicula.title, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption)
          ],
        ),
      );
    }).toList();
  }
}