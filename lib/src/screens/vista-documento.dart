import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:legal/src/database/database_helper.dart';
import 'package:legal/src/database/models/articulo.model..dart';
import 'package:legal/src/widgets/search_field.dart';
import 'package:share/share.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:toast/toast.dart';

class VistaDocumento extends StatefulWidget {
  VistaDocumento({Key key}) : super(key: key);

  @override
  _VistaDocumentoState createState() => _VistaDocumentoState();
}

class _VistaDocumentoState extends State<VistaDocumento> {
  DBHelper dbHelper = new DBHelper();
  List<Articulo> listadoArticulos = [];
  List<Articulo> listado = [];
  String searchText = '';
  String pdf;
  TextEditingController controller;
  bool firstTime = true;
  Box box;

  @override
  void initState() {
    super.initState();
    _initDataBase();
    initBox();
    controller = TextEditingController();
    // listado = [];
  }

  Future _initDataBase() async {
    await dbHelper.initDB();
    setState(() {});
  }

  void initBox() async {
    await Hive.openBox('favoritos');
    box = Hive.box('favoritos');
  }

  Future _getArticulos() async {
    // await dbHelper.initDB();
    var data;
    switch (pdf) {
      case 'constitucion':
        data = dbHelper.loadConstitucion();
        break;
      case 'penal':
        data = dbHelper.loadPenal();
        break;
      default:
    }
    return data;
  }

  void _settingModalBottomSheet(BuildContext context, Articulo articulo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Opciones:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                new ListTile(
                    leading: new Icon(Icons.favorite),
                    title: new Text('Agregar a favorito'),
                    onTap: () {
                      _addToFavorite(articulo);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                    leading: new Icon(Icons.share),
                    title: new Text('Compartir'),
                    onTap: () {
                      _sharedArticulo(articulo);
                      Navigator.of(context).pop();
                    }),
                /* new ListTile(
                  leading: new Icon(Icons.announcement),
                  title: new Text('Reportar'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ), */
              ],
            ),
          );
        });
  }

  void _showArticulo(BuildContext context, int index, String tipo) {
    Navigator.of(context).pushNamed('/vista-articulo',
        arguments:
            ModeloArticulo(index, listado, searchText: searchText, tipo: tipo));
  }

  void _addToFavorite(Articulo articulo) {
    if (_isFavorite(box, articulo)) {
      Toast.show(
        'Este artículo ya esta en Favoritos',
        context,
        backgroundColor: Colors.red[900],
        duration: Toast.LENGTH_LONG,
      );
    } else {
      box.put(_getFormatedText(articulo.tipo) + articulo.name.split(' ')[1],
          articulo);
      Toast.show(
        'Artículo agregado a Favoritos',
        context,
        backgroundColor: Colors.green[900],
        duration: Toast.LENGTH_LONG,
      );
    }
    print(box.values.length);
    // box.clear();
  }

  bool _isFavorite(Box box, Articulo articulo) {
    // print(box.values.toList()[0].description);
    bool isFavorite = false;
    box.values.toList().forEach((element) {
      print(element.description == articulo.description);
      if (element.description == articulo.description) {
        isFavorite = true;
      }
    });
    return isFavorite;
  }

  void _sharedArticulo(Articulo articulo) {
    String subject =
        articulo.tipo + '\n' + articulo.name + '\n' + articulo.description;
    Share.share(subject);
  }

  @override
  void dispose() {
    super.dispose();
    StatusbarUtil.setStatusBarFont(FontStyle.black);
  }

  void _search(String value) async {
    if (value.isEmpty) {
      setState(() {
        listado = listadoArticulos;
      });
    } else {
      List<Articulo> listadoFiltrado = await _filter(value);
      print('llego');
      setState(() {
        listado = listadoFiltrado;
      });
    }
  }

  Future<List<Articulo>> _filter(String value) {
    return Future.sync(() {
      List<Articulo> aux = [];
      aux = listadoArticulos.where((element) {
        return _getFormatedText(element.description)
                .contains(_getFormatedText(value)) ||
            _getFormatedText(element.name).contains(_getFormatedText(value));
      }).toList();
      return aux;
    });
  }

  String _getFormatedText(String value) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      value = value.replaceAll(withDia[i], withoutDia[i]);
    }
    value = value.toLowerCase();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    StatusbarUtil.setStatusBarFont(FontStyle.white);
    pdf = ModalRoute.of(context).settings.arguments;
    // pdf = 'constitucion';
    String title;
    String imageBackground;
    String tag;
    switch (pdf) {
      case 'constitucion':
        title = 'Constitución de La República de Cuba';
        imageBackground = 'assets/img/constitucion.jpg';
        tag = 'constitucion';
        break;
      case 'penal':
        title = 'Código Penal';
        imageBackground = 'assets/img/penal.jpg';
        tag = 'penal';
        break;
    }
    return Scaffold(
      body: FutureBuilder(
        future: _getArticulos(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Map> aux = snapshot.data as List<Map>;

            // listadoArticulos = snapshot.data as List<Articulo>;
            if (firstTime) {
              aux.forEach((element) {
                String name = 'Artículo ' + element['name'].toString();
                String descripcion = element['description'];
                String tipo = title;
                listadoArticulos.add(new Articulo(name, descripcion, tipo));
              });
              firstTime = false;
              listado = listadoArticulos;
            }

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: false,
                  stretch: true,
                  pinned: true,
                  title: Text(title),
                  collapsedHeight: 130,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(
                        left: 50, top: 16, bottom: 16, right: 50),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'pepe',
                          child: Image.asset(
                            imageBackground,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        )
                      ],
                    ),
                    collapseMode: CollapseMode.parallax,
                  ),
                  expandedHeight: 300,
                  bottom: PreferredSize(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: SearchField(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          onTextChange: (String value) {
                            searchText = value;
                            _search(value);
                            // initState();
                          },
                        ),
                      ),
                      preferredSize: Size.fromHeight(10)),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Articulo articulo = listado[index];
                      return Column(
                        children: [
                          Container(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                _showArticulo(context, index, title);
                              },
                              onLongPress: () {
                                _settingModalBottomSheet(context, articulo);
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        articulo.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      RichText(
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 18,
                                          ),
                                          text: articulo.description,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Divider(
                                        height: 0,
                                        thickness: 1,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: listado.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: listado.isEmpty,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Center(
                        child: Text('No se encontro ningun articulo'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        },
      ),
    );
  }
}

class ModeloArticulo {
  final dynamic index;
  final List listado;
  final String searchText;
  final String tipo;
  final bool isFavorite;

  ModeloArticulo(this.index, this.listado,
      {this.searchText, this.tipo, this.isFavorite});
}
