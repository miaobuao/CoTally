import 'package:cotally/generated/l10n.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final db = DB();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.appName),
      ),
      drawer: Drawer(
        child: Obx(() => ListView.builder(
            itemCount: db.remoteRepo.length.value,
            itemBuilder: (context, idx) {
              final data = db.remoteRepo.get(idx);
              return ListTile(
                title: Text(data.id),
                subtitle: Text(data.updateTime.toString()),
              );
            })),
      ),
      body: Container(),
    );
  }
}
