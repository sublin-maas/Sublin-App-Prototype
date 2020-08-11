import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({
    this.title = '',
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: AppBar(
        title: Text(this.title),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Image.asset(
          'assets/images/Sublin.png',
          scale: 1.2,
        ),
      ),
    );
  }
}
