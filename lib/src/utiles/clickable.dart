import 'package:flutter/material.dart';

class ClickableContainer extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Function onLongPress;
  final bool showEfects;
  ClickableContainer(
      {this.child, Key key, this.onTap, this.showEfects, this.onLongPress})
      : super(key: key);

  @override
  _ClickableContainerState createState() => _ClickableContainerState();
}

class _ClickableContainerState extends State<ClickableContainer> {
  double padding = 0;

  _updatingPadding(value) {
    setState(() {
      padding = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (widget.showEfects) {
          _updatingPadding(5.0);
        }
      },
      onTapUp: (details) {
        if (widget.showEfects) {
          _updatingPadding(0.0);
        }
      },
      onLongPress: () {
        // widget.showEfects && _updatingPadding(0.0);
        widget.onLongPress();
      },
      onTapCancel: () {
        if (widget.showEfects) {
          _updatingPadding(0.0);
        }
      },
      onTap: () {
        // widget.showEfects && _updatingPadding(5.0);
        // if (widget.showEfects) {
        //   Timer(Duration(milliseconds: 300), () => _updatingPadding(0.0));
        // }
        widget.onTap();
      },
      child: AnimatedPadding(
        padding: EdgeInsets.all(padding),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
