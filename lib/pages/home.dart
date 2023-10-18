import 'package:cotally/utils/locale.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoTally".i18n),
      ),
      drawer: Drawer(
        child: ListView(
          // padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(child: Text("head")),
            ListTile(
              title: Text('Item 1'),
              leading: new CircleAvatar(
                child: new Icon(Icons.school),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              leading: new CircleAvatar(
                child: new Text('B2'),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 3'),
              leading: new CircleAvatar(
                child: new Icon(Icons.list),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
