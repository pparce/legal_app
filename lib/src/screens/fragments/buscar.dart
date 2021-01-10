import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class Buscar extends StatefulWidget {
  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Filtro de Busqueda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                new ListTile(
                    leading: new Icon(Icons.favorite),
                    title: new Text('Agregar a favorito'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.announcement),
                  title: new Text('Reportar'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Container(
        margin: EdgeInsets.only(top: statusBarHeight + 16, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[500],
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 16),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20),
                              cursorColor: Colors.black,
                              decoration: new InputDecoration(
                                hintStyle: TextStyle(fontSize: 18),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Buscar...',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 25,
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
