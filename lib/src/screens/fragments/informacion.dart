import 'package:animate_do/animate_do.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

class Informacion extends StatefulWidget {
  Informacion({Key key}) : super(key: key);

  @override
  _InformacionState createState() => _InformacionState();
}

class _InformacionState extends State<Informacion>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      setState(() {});
      print("Selected Index: " + _controller.index.toString());
    });
  }

  void _copyToClipBoard(String texto) {
    FlutterClipboard.copy(texto).then((value) {
      Toast.show(
        'Texto copiado',
        context,
        backgroundColor: Colors.green[900],
        duration: Toast.LENGTH_LONG,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String descripcion =
        'Intenté crear una vía fácil y sencilla de acceder a los principales documentos legales cubanos. Seguiré trabajando para agregar más documentos y mejorar la experiencia de usuario. Cualquier información o sugerencia puede hacerlo a través de mis contactos. Saludos y gracias por usar la aplicación :)';
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return FadeIn(
      duration: Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 16, top: 16),
              child: Text(
                'LEGAL v1.0',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: descripcion,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Creado por:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text('Téc. Pedro Pablo Arce Aguilera'),
                      ],
                    ),
                  ),
                  /* Text(
                    'Contactos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), */
                  ListTile(
                    leading: Icon(Icons.call),
                    title: Text('+53 58358801'),
                    onTap: () {
                      _copyToClipBoard('+53 58358801');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('pedropablo2337@gmail.com'),
                    onTap: () {
                      _copyToClipBoard('pedropablo2337@gmail.com');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
