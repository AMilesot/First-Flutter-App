

import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/seach_delegate.dart';


import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
 
 final peliculasProvider = new PeliculasProvider();
 

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopular('popular', 1);
    final _screenSize = MediaQuery.of(context).size;

    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: Text('Peliculas'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search), 
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSeach()
                );
              }, 
            )
          ],
        ),
        body: Container(
          child: ClipRect(
            child: ListView(
            //Column(
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             //scrollDirection: Axis.horizontal,
              
              children: <Widget>[
                SizedBox(height: _screenSize.height * .015),
                _swiperTarjetas(),
                SizedBox(height: _screenSize.height * .07),
                _footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _swiperTarjetas (){

    return FutureBuilder(
      future: peliculasProvider.getEnCines('now_playing',1),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData) return CardSwiper(peliculas: snapshot.data);
        else return Container(
          height: 325.0,
          child: Center(
            child: CircularProgressIndicator() 
          )
        );

      },
    );
    //return Container();
  }
    
  Widget _footer(BuildContext context) {
    
    return Container(

      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.headline6)
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if(snapshot.hasData)
                return MovieHorizontal(

                  peliculas: snapshot.data,
                  nextPage: peliculasProvider.getPopular,
                );
                else return  Container(
                height: 275.0,
                child: Center(
                  child: CircularProgressIndicator() 
                ),
              );
            },
          ),
        ],
      ),
    );    
  }

}