import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_modelo.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey   = "90c9cdc9dab43b727f95023f074f92ec";
  String _url      = "api.themoviedb.org";
  String _language = "es-ES";

  int _popularespage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();  // tuveria del stream (infraestructura )

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add; // Añade informacion a la tuveria

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream; // Escucha el flujo de datos del stream controller que vienen del sink

  void disposeStreams() {
    _popularesStreamController?.close(); // ? pregunta su tiene info el stream controller
  }

  Uri url (String endPoint, int peticion, String query) {   
    String _unencodedPath;
    switch (peticion) {
      case 1:{
        _unencodedPath = '3/movie/$endPoint';
        break;
      }
      case 2 :{
        _unencodedPath = '3/movie/$endPoint/credits';
        break;
      }
      case 3 :{
        _unencodedPath = '3/search/movie';
        break;
      }
        
      default:{
        _unencodedPath = '3/movie/$endPoint';
      }
    }
   return Uri.https(_url, _unencodedPath,{
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularespage.toString(),
      'query'    : query,
    });
  }

  Future<List<Pelicula>> _decodificarData (String endPoint, int peticion, String query) async {

    final resp = await http.get(url(endPoint, peticion,query));
    final decodedData = json.decode(resp.body);
    
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Actor>> _decodedData (String endPoint, int peticion) async {

    final resp = await http.get(url(endPoint, peticion,''));
    final decodedData = json.decode(resp.body);
    
    final actores = new Actores.fromJsonList(decodedData['cast']);
    return actores.actores;
  }

  Future <List<Pelicula>> getEnCines (String endPoint, int peticion) async => await _decodificarData (endPoint, peticion,'');

  Future <List<Pelicula>> getPopular (String endPoint, int peticion) async  {

    if (_cargando) return [];
    
    _cargando = true;
    _popularespage++;

    final resp = await _decodificarData(endPoint,peticion,'');
    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future <List<Actor>> getActores (String endPoint, int peticion) async {
    
     _popularespage++;
     final resp = await _decodedData(endPoint, peticion);
     return resp;
  }

   Future <List<Pelicula>> buscarMovie (String endPoint, int peticion, String query) async => await _decodificarData (endPoint, peticion, query);

}