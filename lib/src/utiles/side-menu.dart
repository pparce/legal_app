import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi, min;

/// Shrink Side Menu Types
enum SideMenuType {
  /// child will shrink slide and rotate when sidemenu opens
  shrikNRotate,

  /// child will shrink and slide when sidemenu opens
  shrinkNSlide,

  /// child will slide and rotate when sidemenu opens
  slideNRotate,

  /// child will slide when sidemenu opens
  slide,
}

/// Liquid Shrink Side Menu is compatible with [Liquid ui](https://pub.dev/packages/liquid_ui)
///
/// Create a SideMenu / Drawer
///
class SideMenu extends StatefulWidget {
  final int _inverse;

  /// Widget that should be enclosed in sidemenu
  ///
  /// generally a [Scaffold] and should not be `null`
  final Widget child;

  /// Background color of the side menu
  ///
  /// default: Color(0xFF112473)
  final Color background;

  /// Radius for the child when side menu opens
  final BorderRadius radius;

  /// Close Icon
  final Icon closeIcon;

  /// Menu that should be in side menu
  ///
  /// generally a [SingleChildScrollView] with a [Column]
  final Widget menu;

  /// Maximum constrints for menu width
  ///
  /// default: `275.0`
  final double maxMenuWidth;

  /// Type of Side menu
  ///
  /// 1. shrikNRotate
  /// 2. shrinkNSlide
  /// 3. slideNRotate
  /// 4. slide
  final SideMenuType type;

  /// Liquid Shrink Side Menu is compatible with [Liquid ui](https://pub.dev/packages/liquid_ui)
  ///
  /// Create a SideMenu / Drawer
  ///
  ///
  ///```dart
  ///
  ///final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  ///
  ///SideMenu(
  ///    key: _sideMenuKey, // to toggle this sidemenu
  ///    menu: buildMenu(),
  ///    type: SideMenuType.slideNRotate, // check above images
  ///    child: Scaffold(
  ///        appBar: AppBar(
  ///            leading: IconButton(
  ///              icon: Icon(Icons.menu),
  ///              onPressed: () {
  ///                final _state = _sideMenuKey.currentState;
  ///                if (_state.isOpened)
  ///                  _state.closeDrawer(); // close side menu
  ///                else
  ///                  _state.openDrawer();// open side menu
  ///              },
  ///            ),
  ///        ...
  ///    ),
  ///);
  ///```
  ///
  ///Set `inverse` equals `true` to create end sidemenu
  ///
  const SideMenu({
    Key key,
    this.child,
    this.background,
    this.radius,
    this.closeIcon = const Icon(
      Icons.close,
      color: const Color(0xFFFFFFFF),
    ),
    this.menu,
    this.type = SideMenuType.shrikNRotate,
    this.maxMenuWidth = 275.0,
    bool inverse = false,
  })  : assert(child != null),
        assert(menu != null),
        assert(type != null),
        assert(inverse != null),
        assert(maxMenuWidth != null && maxMenuWidth > 0),
        _inverse = inverse ? -1 : 1,
        super(key: key);

  static SideMenuState of(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<SideMenuState>();
  }

  double degToRad(double deg) => (pi / 180) * deg;

  bool get inverse => _inverse == -1;

  @override
  SideMenuState createState() {
    if (type == SideMenuType.shrikNRotate)
      return ShrinkSlideRotateSideMenuState();
    if (type == SideMenuType.shrinkNSlide) return ShrinkSlideSideMenuState();
    if (type == SideMenuType.slide) return SlideSideMenuState();
    if (type == SideMenuType.slideNRotate) return SlideRotateSideMenuState();
    return null;
  }
}

abstract class SideMenuState extends State<SideMenu> {
  bool _opened;

  /// open SideMenu
  void openSideMenu() => setState(() => _opened = true);

  /// close SideMenu
  void closeSideMenu() => setState(() => _opened = false);

  /// get current status of sidemenu
  bool get isOpened => _opened;

  @override
  void initState() {
    super.initState();
    _opened = false;
  }

  Widget _getCloseButton(double statusBarHeight) {
    return widget.closeIcon != null
        ? Positioned(
            top: statusBarHeight,
            left: widget.inverse ? null : 0,
            right: widget.inverse ? 0 : null,
            child: IconButton(
              icon: widget.closeIcon,
              onPressed: closeSideMenu,
            ),
          )
        : Container();
  }
}

class ShrinkSlideRotateSideMenuState extends SideMenuState {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color(0xFF112473),
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF3366FF),
                const Color(0xFF00CCFF),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: statusBarHeight + (widget?.closeIcon?.size ?? 25.0) * 2,
              bottom: 0.0,
              width: min(size.width * 0.70, widget.maxMenuWidth),
              right: widget._inverse == 1 ? null : 0,
              child: widget.menu,
            ),
            _getCloseButton(statusBarHeight),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.fastLinearToSlowEaseIn,
              transform: _getMatrix4(size),
              decoration: BoxDecoration(
                  borderRadius: _getBorderRadius(),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 18.0),
                        color: Colors.black12,
                        blurRadius: 32.0)
                  ]),
              child: _getChild(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChild() => _opened
      ? SafeArea(
          child: ClipRRect(
            borderRadius: _getBorderRadius(),
            clipBehavior: Clip.antiAlias,
            child: widget.child,
          ),
        )
      : widget.child;

  BorderRadius _getBorderRadius() => _opened
      ? (widget.radius ?? BorderRadius.circular(34.0))
      : BorderRadius.zero;

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      return Matrix4.identity()
        ..rotateZ(widget.degToRad(5.0 * widget._inverse))
        ..invertRotation()
        ..translate(
            min(size.width, widget.maxMenuWidth) *
                widget._inverse *
                (widget.inverse ? 0.6 : 0.9),
            (size.height * 0.1))
        ..scale(widget.maxMenuWidth / size.width ?? 0.8, 0.8);
    }
    return Matrix4.identity();
  }
}

class ShrinkSlideSideMenuState extends SideMenuState {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color(0xFF112473),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: statusBarHeight + (widget?.closeIcon?.size ?? 25.0) * 2,
            bottom: 0.0,
            width: min(size.width * 0.70, widget.maxMenuWidth),
            right: widget._inverse == 1 ? null : 0,
            child: widget.menu,
          ),
          _getCloseButton(statusBarHeight),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            alignment: Alignment.topLeft,
            transform: _getMatrix4(size),
            decoration: BoxDecoration(
              borderRadius: _getBorderRadius(),
            ),
            child: _getChild(),
          ),
        ],
      ),
    );
  }

  Widget _getChild() => _opened
      ? SafeArea(
          child: GestureDetector(
            onTap: () {
              closeSideMenu();
            },
            child: AbsorbPointer(
              ignoringSemantics: false,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: Colour('#00000', 0.1),
                      offset: const Offset(15.0, 15.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: _getBorderRadius(),
                  clipBehavior: Clip.antiAlias,
                  child: widget.child,
                ),
              ),
            ),
          ),
        )
      : widget.child;

  BorderRadius _getBorderRadius() => _opened
      ? (widget.radius ?? BorderRadius.circular(10))
      : BorderRadius.zero;

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      return Matrix4.identity()
        ..translate(
            min(size.width, widget.maxMenuWidth) *
                widget._inverse *
                (widget.inverse ? 0.5 : 0.9),
            (size.height * 0.15))
        ..scale(widget.maxMenuWidth / size.width ?? 0.5, 0.7);
    }
    return Matrix4.identity();
  }
}

class SlideRotateSideMenuState extends SideMenuState {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color(0xFF112473),
      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: statusBarHeight + (widget?.closeIcon?.size ?? 25.0) * 2,
              bottom: 0.0,
              width: min(size.width * 0.70, widget.maxMenuWidth),
              right: widget._inverse == 1 ? null : 0,
              child: widget.menu,
            ),
            _getCloseButton(statusBarHeight),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              transform: _getMatrix4(size),
              decoration: BoxDecoration(
                  borderRadius: _getBorderRadius(),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 18.0),
                        color: Colors.black12,
                        blurRadius: 32.0)
                  ]),
              child: _getChild(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChild() => _opened
      ? SafeArea(
          child: GestureDetector(
            onTap: () {
              closeSideMenu();
            },
            child: AbsorbPointer(
              ignoringSemantics: false,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: Colour('#00000', 0.5),
                      offset: const Offset(15.0, 15.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: _getBorderRadius(),
                  clipBehavior: Clip.antiAlias,
                  child: widget.child,
                ),
              ),
            ),
          ),
        )
      : widget.child;

  BorderRadius _getBorderRadius() => _opened
      ? (widget.radius ?? BorderRadius.circular(34.0))
      : BorderRadius.zero;

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      return Matrix4.identity()
        ..rotateZ(widget.degToRad(-5.0 * widget._inverse))
        // ..scale(0.8, 0.8)
        ..translate(min(size.width, widget.maxMenuWidth) * widget._inverse,
            (size.height * 0.15))
        ..invertRotation();
    }
    return Matrix4.identity();
  }
}

class SlideSideMenuState extends SideMenuState {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color(0xFF112473),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: statusBarHeight + (widget?.closeIcon?.size ?? 25.0) * 2,
            width: min(size.width * 0.70, widget.maxMenuWidth),
            right: widget._inverse == 1 ? null : 0,
            child: widget.menu,
          ),
          _getCloseButton(statusBarHeight),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastLinearToSlowEaseIn,
            alignment: Alignment.topLeft,
            transform: _getMatrix4(size),
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      return Matrix4.identity()
        ..translate(
            min(size.width * 0.70, widget.maxMenuWidth) * widget._inverse);
    }
    return Matrix4.identity();
  }
}
