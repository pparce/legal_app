import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:legal/src/database/models/articulo.model..dart';
import 'package:legal/src/screens/vista-documento.dart';
import 'package:legal/src/utiles/action-floating-buttom/flutter_speed_dial.dart';
import 'package:legal/src/utiles/action-floating-buttom/src/speed_dial.dart';
import 'package:share/share.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:toast/toast.dart';

class VistaArticulo extends StatefulWidget {
  final ModeloArticulo modeloArticulo;
  VistaArticulo({Key key, this.modeloArticulo}) : super(key: key);

  @override
  _VistaArticuloState createState() => _VistaArticuloState();
}

class _VistaArticuloState extends State<VistaArticulo> {
  int index;
  ScrollController scrollController;
  bool dialVisible = true;
  Box box;
  Articulo articulo;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    initBox();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void initBox() async {
    await Hive.openBox('favoritos');
    box = Hive.box('favoritos');
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      backgroundColor: Theme.of(context).primaryColor,
      overlayColor: Colors.white,
      animationSpeed: 100,
      overlayOpacity: 0.8,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.easeInOut,
      children: [
        // SpeedDialChild(
        //   child: Icon(
        //     Icons.announcement,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onTap: () => print('SECOND CHILD'),
        //   label: 'Reportar',
        //   labelBackgroundColor: Theme.of(context).primaryColor,
        //   labelStyle:
        //       TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        //   // labelBackgroundColor: Colors.green,
        // ),
        SpeedDialChild(
          child: Icon(Icons.share, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            _shareArticulo(articulo);
          },
          label: 'Compartir',
          labelBackgroundColor: Theme.of(context).primaryColor,
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            _addToFavorite(articulo);
          },
          label: 'Agregar a Favorito',
          labelBackgroundColor: Theme.of(context).primaryColor,
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          // labelBackgroundColor: Colors.green,
        ),
      ],
    );
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

  void _shareArticulo(Articulo articulo) {
    String subject =
        articulo.tipo + '\n' + articulo.name + '\n' + articulo.description;
    Share.share(subject);
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord.isNotEmpty) {
      do {
        // look for the next match
        final startIndex = _getFormatedText(text)
            .indexOf(_getFormatedText(matchWord), spanBoundary);

        // if no more matches then add the rest of the string without style
        if (startIndex == -1) {
          spans.add(TextSpan(text: text.substring(spanBoundary)));
          return spans;
        }

        // add any unstyled text before the next match
        if (startIndex > spanBoundary) {
          spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
        }

        // style the matched text
        final endIndex = startIndex + matchWord.length;
        final spanText = text.substring(startIndex, endIndex);
        spans.add(TextSpan(text: spanText, style: style));

        // mark the boundary to start the next search from
        spanBoundary = endIndex;

        // continue until there are no more matches
      } while (spanBoundary < text.length);
    } else {
      spans.add(TextSpan(text: text));
    }

    return spans;
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
    ModeloArticulo modeloArticulo = ModalRoute.of(context).settings.arguments;

    print(modeloArticulo.searchText);
    if (index == null) {
      index = modeloArticulo.index;
    }
    print(index);
    var title = modeloArticulo.listado[index].name;
    var description = modeloArticulo.listado[index].description;
    var searchText = modeloArticulo.searchText;
    articulo = Articulo(title, description, modeloArticulo.tipo);
    isFavorite = modeloArticulo.isFavorite ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (index + 1).toString() + ' de ${modeloArticulo.listado.length}'),
        actions: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: (index >= 1)
                ? () {
                    setState(() {
                      index--;
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: (index < modeloArticulo.listado.length - 1)
                ? () {
                    setState(() {
                      index++;
                    });
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: _getSpans(
                        description,
                        searchText,
                        TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isFavorite
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _shareArticulo(articulo);
              },
              child: Icon(Icons.share),
            )
          : buildSpeedDial(),
    );
  }
}
