import 'dart:async';

import 'package:cotally/component/icons.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/utils/api/api.dart';
import 'package:cotally/utils/datetime.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

final store = Store();

class WorkspacePage extends StatelessWidget {
  final db = DB();
  String workspaceId = store.workspace.currentId.value;
  WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.appName),
      ),
      drawer: Drawer(
        child: Obx(() => ListView.builder(
            itemCount: store.workspace.count.value,
            itemBuilder: (context, idx) {
              final data = db.remoteRepo.getByIndex(idx);
              final owner = db.users.get(data.ownerId);
              return FutureBuilder(
                future: owner,
                builder: (context, snapshot) {
                  return Skeletonizer(
                    enabled: isWaiting(snapshot.connectionState),
                    child: ListTile(
                      title: Text(snapshot.data?.info.name ?? ''),
                      subtitle: Text(timeFormat(data.updateTime)),
                      leading: Icon(GitAppIconData.of(snapshot.data?.org)),
                      onTap: () {},
                    ),
                  );
                },
              );
            })),
      ),
      body: Obx(() {
        if (workspaceId != store.workspace.currentId.value) {
          workspaceId = store.workspace.currentId.value;
        }
        return FutureBuilder(
          future: Future.microtask(() async {
            final api = db.workspaces.getApi(workspaceId);
            if (api == null) return null;
            return await api.listRepos();
          }),
          builder: (context, snapshot) {
            if (isWaiting(snapshot.connectionState)) {
              return Text("loading");
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data?[index].url ?? ''),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

bool isWaiting(ConnectionState state) {
  return state != ConnectionState.done;
}
