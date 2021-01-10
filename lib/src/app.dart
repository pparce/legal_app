import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:legal/src/screens/principal.dart';
import 'package:legal/src/screens/prueba.dart';
import 'package:legal/src/screens/vista-articulo.dart';
import 'package:legal/src/screens/vista-pdf.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:legal/src/screens/vista-documento.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    StatusbarUtil.setTranslucent();
    StatusbarUtil.setStatusBarFont(FontStyle.black);
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          primaryColor: Colour('#2E2E32'),
          textTheme: TextTheme(
            // bodyText1: TextStyle(color: Colour('#2E2E32'), fontSize: 50),
            bodyText2: TextStyle(fontSize: 18, height: 1.25),
          ),
          /* Theme.of(context).textTheme.apply(
                bodyColor: Colour('#2E2E32'),
                displayColor: Colour('#2E2E32'),
                fontFamily: 'baloo',
              ), */
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'baloo'),
      initialRoute: '/principal',
      routes: {
        '/principal': (BuildContext context) => Principal(),
        '/vista-documento': (BuildContext context) => VistaDocumento(),
        '/vista-pdf': (BuildContext context) => VistaPdf(),
        '/vista-articulo': (BuildContext context) => VistaArticulo(),
        '/prueba': (BuildContext context) => OpenContainerTransformDemo(),
      },
    );
  }
}
