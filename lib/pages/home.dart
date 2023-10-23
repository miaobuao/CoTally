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
              final owner = db.users.get(data.ownerId);
              return FutureBuilder(
                future: owner,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListTile(
                      title: Text(snapshot.data?.info.name ?? ''),
                      subtitle: Text(data.updateTime.toString()),
                      leading: const Icon(Icons.storage_rounded),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              );
            })),
      ),
      body: Container(),
    );
  }
}
