import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget with PreferredSizeWidget {
  bool isAppTitle;
  String titleText;
  bool removeBackButton;
  Function? actionFunction;
  Widget? actionWidget;

  AppHeader(
      {this.isAppTitle = false,
      this.titleText = '',
      this.removeBackButton = false,
      this.actionFunction,
      this.actionWidget});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: removeBackButton ? false : true,
      title: Text(
        isAppTitle ? "Flutter Instagram" : titleText,
        style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? "Signatra" : "",
          fontSize: 22.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).accentColor,
      actions: [
        if (actionWidget != null) actionWidget!
        // IconButton(
        //     icon: Icon(Icons.check_circle_outline, color: Colors.black),
        //     onPressed: () => widget.actionFunction),
      ],
    );
  }
}
