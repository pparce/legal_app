import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final BoxDecoration decoration;
  final Function onTextChange;
  SearchField({Key key, this.decoration, this.onTextChange}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController controller;
  bool showClose = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      decoration: widget.decoration,
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                widget.onTextChange(value);
                setState(() {
                  showClose = controller.text.isEmpty ? false : true;
                });
              },
              style: TextStyle(fontSize: 18),
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
          Visibility(
              visible: showClose,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  widget.onTextChange('');
                  setState(() {
                    showClose = false;
                  });
                },
              ))
        ],
      ),
    );
  }
}
