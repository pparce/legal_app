import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:legal/src/utiles/libro-arguments.dart';
import 'package:legal/src/widgets/search_field.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class VistaPdf extends StatefulWidget {
  VistaPdf({Key key}) : super(key: key);

  @override
  _VistaPdfState createState() => _VistaPdfState();
}

class _VistaPdfState extends State<VistaPdf> {
  PdfViewerController _pdfViewerController;
  PdfTextSearchResult _searchResult;
  ScrollController _controller;
  bool dark = false;
  bool search = false;
  String searchText = '';
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _controller = ScrollController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    StatusbarUtil.setStatusBarFont(FontStyle.black);
    _controller.dispose();
  }

  OverlayEntry _overlayEntry;
  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: RaisedButton(
          child: Text('Copy', style: TextStyle(fontSize: 17)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          color: Colors.white,
          elevation: 10,
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  void _search(String value) async {
    _searchResult = await _pdfViewerController?.searchText(value,
        searchOption: TextSearchOption.caseSensitive);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    StatusbarUtil.setStatusBarFont(FontStyle.white);
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final libro = args.libro;
    final titulo = args.title;

    return Scaffold(body: OrientationBuilder(
      builder: (context, orientation) {
        bool appbarVisibility = true;
        if (orientation == Orientation.portrait) {
          return NestedScrollView(
            controller: _controller,
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    floating: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    title: search
                        ? SearchField(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            onTextChange: (String value) {
                              searchText = value;
                              _search(value);
                              // initState();
                            },
                          )
                        : Text(
                            titulo,
                            style: TextStyle(color: Colors.white),
                          ))
              ];
            },
            body: Container(
              child: SfPdfViewer.asset(
                'assets/pdf/$libro.pdf',
                controller: _pdfViewerController,
                searchTextHighlightColor: Colors.red,
                onTextSelectionChanged:
                    (PdfTextSelectionChangedDetails details) {
                  if (details.selectedText == null && _overlayEntry != null) {
                    _overlayEntry.remove();
                    _overlayEntry = null;
                  } else if (details.selectedText != null &&
                      _overlayEntry == null) {
                    _showContextMenu(context, details);
                  }
                },
              ),
            ),
          );
        } else {
          return NestedScrollView(
            controller: _controller,
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [];
            },
            body: Container(
              child: SfPdfViewer.asset(
                'assets/pdf/$libro.pdf',
                controller: _pdfViewerController,
                searchTextHighlightColor: Colors.red,
                onTextSelectionChanged:
                    (PdfTextSelectionChangedDetails details) {
                  if (details.selectedText == null && _overlayEntry != null) {
                    _overlayEntry.remove();
                    _overlayEntry = null;
                  } else if (details.selectedText != null &&
                      _overlayEntry == null) {
                    _showContextMenu(context, details);
                  }
                },
              ),
            ),
          );
        }
      },
    )

        // CustomScrollView(
        //   slivers: [
        //     SliverAppBar(
        //       floating: true,
        //       title: search
        //           ? SearchField(
        //               decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.circular(50)),
        //               onTextChange: (String value) {
        //                 searchText = value;
        //                 _search(value);
        //                 // initState();
        //               },
        //             )
        //           : Text(
        //               titulo,
        //               style: TextStyle(color: Colors.white),
        //             ),
        //       actions: [
        //         // IconButton(
        //         //   icon: Icon(
        //         //     Icons.search,
        //         //     color: Colors.white,
        //         //   ),
        //         //   onPressed: () {
        //         //     setState(() {
        //         //       search = true;
        //         //     });
        //         //   },
        //         // ),
        //         // Visibility(
        //         //   visible: _searchResult?.hasResult ?? false,
        //         //   child: IconButton(
        //         //     icon: Icon(
        //         //       Icons.clear,
        //         //       color: Colors.white,
        //         //     ),
        //         //     onPressed: () {
        //         //       setState(() {
        //         //         _searchResult.clear();
        //         //       });
        //         //     },
        //         //   ),
        //         // ),
        //         // Visibility(
        //         //   visible: _searchResult?.hasResult ?? false,
        //         //   child: IconButton(
        //         //     icon: Icon(
        //         //       Icons.keyboard_arrow_up,
        //         //       color: Colors.white,
        //         //     ),
        //         //     onPressed: () {
        //         //       _searchResult?.previousInstance();
        //         //     },
        //         //   ),
        //         // ),
        //         // Visibility(
        //         //   visible: _searchResult?.hasResult ?? false,
        //         //   child: IconButton(
        //         //     icon: Icon(
        //         //       Icons.keyboard_arrow_down,
        //         //       color: Colors.white,
        //         //     ),
        //         //     onPressed: () {
        //         //       _searchResult?.nextInstance();
        //         //     },
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //     // SliverFillViewport(delegate: null,)
        //     SliverFillRemaining(
        //       hasScrollBody: true,
        //       fillOverscroll: false,
        //       child: Container(
        //         child: SfPdfViewer.asset(
        //           'assets/pdf/$libro.pdf',
        //           controller: _pdfViewerController,
        //           searchTextHighlightColor: Colors.red,
        //           onTextSelectionChanged:
        //               (PdfTextSelectionChangedDetails details) {
        //             if (details.selectedText == null && _overlayEntry != null) {
        //               _overlayEntry.remove();
        //               _overlayEntry = null;
        //             } else if (details.selectedText != null &&
        //                 _overlayEntry == null) {
        //               _showContextMenu(context, details);
        //             }
        //           },
        //         ),
        //       ),
        //     ),
        //     /* SliverToBoxAdapter(
        //       child:
        //     ), */
        //   ],
        // ),
        );
  }
}
