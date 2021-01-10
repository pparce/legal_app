import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:legal/src/database/models/articulo.model..dart';
import 'package:legal/src/screens/vista-documento.dart';
import 'package:share/share.dart';

class Favoritos extends StatefulWidget {
  Favoritos({Key key}) : super(key: key);

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos>
    with SingleTickerProviderStateMixin {
  List articulos = [];
  Box box;

  @override
  void initState() {
    super.initState();
    initBox();
  }

  void initBox() async {
    await Hive.openBox('favoritos');
    box = Hive.box('favoritos');
    articulos = box.values.toList() ?? [];
    /* box.values.toList().forEach((element) {
      articulos.add(element);
    }); */
    setState(() {});
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
                    leading: new Icon(Icons.favorite_border),
                    title: new Text('Eliminar de favorito'),
                    onTap: () {
                      _quitarFavoritio(articulo);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                    leading: new Icon(Icons.share),
                    title: new Text('Compartir'),
                    onTap: () {
                      _sharedArticulo(articulo);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  void _showArticulo(context, index, Articulo articulo) {
    Navigator.of(context).pushNamed('/vista-articulo',
        arguments: ModeloArticulo(index, articulos,
            searchText: '', tipo: articulo.tipo, isFavorite: true));
  }

  void _quitarFavoritio(Articulo articulo) {
    box.delete(_getFormatedText(articulo.tipo) + articulo.name.split(' ')[1]);
    articulos.remove(articulo);
    setState(() {
      articulos = box.values.toList() ?? [];
    });
  }

  void _sharedArticulo(Articulo articulo) {
    String subject =
        articulo.tipo + '\n' + articulo.name + '\n' + articulo.description;
    Share.share(subject);
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
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return FadeIn(
      duration: Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.only(top: statusBarHeight + 16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 16),
              child: Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: articulos.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: articulos.length,
                        itemBuilder: (_, index) {
                          var imagen;
                          Articulo articulo = articulos[index];
                          switch (articulo.tipo) {
                            case 'Constitución de La República de Cuba':
                              imagen = 'assets/img/constitucion.jpg';
                              break;
                            case 'Código Penal':
                              imagen = 'assets/img/penal.jpg';
                              break;
                            case '':
                              break;
                          }
                          return Card(
                            elevation: 2,
                            borderOnForeground: false,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: index == articulos.length - 1 ? 90 : 16,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      _showArticulo(context, index, articulo);
                                    },
                                    onLongPress: () {
                                      _settingModalBottomSheet(
                                          context, articulo);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          /* Image.asset(imagen,
                                              height: 170,
                                              width: double.infinity,
                                              fit: BoxFit.fill),
                                          Container(
                                              height: 170,
                                              width: double.infinity,
                                              color: Colors.black
                                                  .withOpacity(0.6)), */
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 16, right: 16, top: 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        articulo.name,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '(${articulo.tipo})',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  RichText(
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 18,
                                                      ),
                                                      text:
                                                          articulo.description,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 70,
                                color: Colors.grey[400],
                              ),
                              Text(
                                'No hay Favoritos',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
