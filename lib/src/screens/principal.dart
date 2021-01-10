import 'dart:async';

import 'package:colour/colour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legal/src/database/database_helper.dart';
import 'package:legal/src/screens/fragments/informacion.dart';
import 'package:legal/src/screens/fragments/inicio.dart';
import 'package:legal/src/screens/fragments/favoritos.dart';
import 'package:legal/src/utiles/bottom-bar.dart';
import 'package:legal/src/utiles/side-menu.dart';

class Principal extends StatefulWidget {
  Principal({Key key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _selectedIndex = 0;
  bool showBottomBar = true;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final _scaffKey = GlobalKey<ScaffoldState>();
  final TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  bool canExit = false;

  var _selectedTab = _SelectedTab.incio;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
    DBHelper dbHelper = new DBHelper();
    dbHelper.initDB();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _onBackPressed(BuildContext context) {
    print(canExit);
    if (_selectedIndex == 0) {
      if (canExit) {
        return true;
      } else {
        setState(() {
          canExit = true;
        });
        Timer(const Duration(milliseconds: 2000), () {
          setState(() {
            canExit = false;
          });
        });
        final snackBar = SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Text('Presione una vez más para cerrar'),
        );
        _scaffKey.currentState.showSnackBar(snackBar);

        return false;
      }
    } else {
      setState(() {
        _selectedIndex = 0;
        _selectedTab = _SelectedTab.values[0];
      });
      return false;
    }
  }

  _getBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        transform: showBottomBar
            ? Matrix4.translationValues(0, 0, 0)
            : Matrix4.translationValues(0, 100, 0),
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colour('#2E2E32'),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colour('#00000', 0.2),
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: SalomonBottomBar(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    duration: Duration(milliseconds: 300),
                    currentIndex: _SelectedTab.values.indexOf(_selectedTab),
                    selectedItemColor: Colour('#ffffff'),
                    unselectedItemColor: Colors.grey[300],
                    itemPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    onTap: _onItemTapped,
                    items: [
                      SalomonBottomBarItem(
                        icon: Icon(
                          Icons.home,
                        ),
                        title: Text(
                          "INICIO",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      /* SalomonBottomBarItem(
                          icon: Icon(
                            Icons.search,
                          ),
                          title: Text("BUSCAR",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ), */
                      SalomonBottomBarItem(
                        icon: Icon(
                          Icons.favorite,
                        ),
                        title: Text("FAVORITOS",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SalomonBottomBarItem(
                        icon: Icon(
                          Icons.info,
                        ),
                        title: Text("INFORMACIÓN",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Inicio(
        isScrollingDown: (value) {
          setState(() {
            showBottomBar = !value;
          });
        },
      ),
      // VistaDocumento(),
      Favoritos(),
      Informacion(),
    ];
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
      },
      child: Scaffold(
        key: _scaffKey,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: AnimatedSwitcher(
                reverseDuration: Duration(milliseconds: 0),
                switchInCurve: Curves.fastLinearToSlowEaseIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                duration: Duration(milliseconds: 800),
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
            _getBottomBar(),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { incio, buscar, favoritos, ajustes }
