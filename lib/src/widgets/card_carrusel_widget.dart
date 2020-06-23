import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class CarruselCard  extends StatelessWidget {
final List<Pelicula> peliculas;

CarruselCard({@required this.peliculas});


  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 15.0),
     // width: _screenSize.width * .2,
      height: _screenSize.height * .2,
      child: GridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        scrollDirection: Axis.horizontal,
        children: List.generate(peliculas.length, (index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage(peliculas[index].getPostImg()),
                fit: BoxFit.fill,
              ),
            );
          }),
      ),
    );
  }
}