import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final db = DB();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoTally".i18n),
      ),
      drawer: Drawer(
        child: Obx(() => ListView.builder(
            itemCount: db.remoteRepo.length.value,
            itemBuilder: (context, idx) {
              final data = db.remoteRepo.get(idx);
              return ListTile(
                title: Text(data.username),
                subtitle: Text(data.updateTime.toString()),
              );
            })),
      ),
      body: Container(),
    );
  }
}
