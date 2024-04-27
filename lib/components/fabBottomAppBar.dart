import 'package:flutter/material.dart';

import '../Utils/constants.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, required this.text});
  final IconData iconData;
  final String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    this.centerItemText,
    this.height = 60.0,
    this.iconSize = 20.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
  });

  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  _FABBottomAppBarState createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTabItem({
      required FABBottomAppBarItem item,
      required int index,
      required ValueChanged<int> onPressed,
    }) {
      bool isSelected = _selectedIndex == index;
      Color color = isSelected ? Color(0xFF0270f0) : Color(0xFF002C46);
      Color iconColor = isSelected ? Color(0xFF0270f0) : Color(0xFF002C46);
      return Expanded(

        child: SizedBox(
          height: widget.height,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => onPressed(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Icon(item.iconData, color: iconColor, size: widget.iconSize),
                  ),
                  SizedBox(height: 2.0),
                  Text(item.text, style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return PreferredSize(
      preferredSize: Size.fromHeight(widget.height),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),

        ),
        child: Container(
          height: widget.height + 20.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(.5),
                spreadRadius: 2,
                blurRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(.5),
                spreadRadius: 0,
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomAppBar(
            elevation: 10,
            color: Colors.white,
            surfaceTintColor: kColorDarkRed,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
