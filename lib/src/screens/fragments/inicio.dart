import 'package:animate_do/animate_do.dart';
import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:legal/src/utiles/libro-arguments.dart';

class Inicio extends StatefulWidget {
  final Function isScrollingDown;

  Inicio({Key key, this.isScrollingDown}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  ScrollController _scrollViewController;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          widget.isScrollingDown(true);
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          widget.isScrollingDown(false);
          // setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.removeListener(() {});
    _scrollViewController.dispose();
  }

  _settingModalBottomSheet(context, pdf, titulo, disableList) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Modos de Vista',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: new Icon(Icons.import_contacts),
                  title: new Text('Vista PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _openPdf(pdf, titulo);
                  },
                ),
                disableList
                    ? ListTile(
                        enabled: false,
                        leading: new Icon(Icons.format_list_numbered),
                        title:
                            new Text('Separadas por Artículos (proximamente)'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushNamed('/vista-documento', arguments: pdf);
                        })
                    : ListTile(
                        leading: new Icon(Icons.format_list_numbered),
                        title: new Text('Separadas por Artículos'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushNamed('/vista-documento', arguments: pdf);
                        }),
              ],
            ),
          );
        });
  }

  void _openPdf(pdf, title) {
    Navigator.of(context)
        .pushNamed('/vista-pdf', arguments: ScreenArguments(title, pdf));
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return FadeIn(
      duration: Duration(milliseconds: 300),
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          height: double.infinity,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 16, top: 16),
                child: Text(
                  'Documentos oficiales',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: false,
                  padding: EdgeInsets.zero,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(
                            context, 'constitucion', 'Constitución', false);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/img/constitucion.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                height: 200,
                                width: double.infinity,
                                color: Colour('#000000', 0.5),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Text(
                                  'Constitución\nde La República de Cuba',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(
                            context, 'penal', 'Código Penal', false);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/img/penal.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                height: 200,
                                color: Colour('#000000', 0.5),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Hero(
                                  tag: 'titulo',
                                  child: Text(
                                    'Código Penal',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(
                            context, 'vial', 'Código Vial', true);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/img/transito.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                height: 200,
                                color: Colour('#000000', 0.5),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Text(
                                  'Código Vial',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(context, 'vivienda',
                            'Ley General de la Vivienda', true);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/img/vivienda.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                height: 200,
                                color: Colour('#000000', 0.5),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Text(
                                  'Ley General de la Vivienda',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
