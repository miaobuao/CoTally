import 'package:cotally/component/button.dart';
import 'package:cotally/component/dialog.dart';
import 'package:cotally/component/header.dart';
import 'package:cotally/component/icons.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/datetime.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

final store = Store();

// ignore: must_be_immutable
class WorkspacePage extends StatelessWidget {
  final db = DB();
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
        final workspaceId = store.workspace.currentId.value;
        return FutureBuilder(
          future: db.workspaces.get(workspaceId),
          builder: (context, snapshot) {
            if (isWaiting(snapshot.connectionState)) {
              return LoadingDialog();
            }
            final itemCount = snapshot.data?.books.length ?? 0;
            if (itemCount == 0) {
              return const Text("empty");
            }
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data?.books[index].url ?? ''),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CreateRepoDialog();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

bool isWaiting(ConnectionState state) {
  return state != ConnectionState.done;
}

class CreateRepoDialog extends StatelessWidget {
  final name = "".obs;
  final summary = "".obs;
  final org = Org.gitee.obs;
  final public = true.obs;
  CreateRepoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(
      height: 10,
    );
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Repo",
              style: TextStyle(fontSize: 24),
            ),
            space,
            Input(
              hint: "name",
              value: name,
              autofocus: true,
            ),
            space,
            Input(
              hint: 'summary',
              value: summary,
            ),
            space,
            Obx(() => SwitchListTile(
                title: const Text("public"),
                value: public.value,
                onChanged: (value) {
                  public.value = value;
                }))
          ]).paddingOnly(top: 10),
      actions: [
        TextButton(
          onPressed: () {
            dismiss(context);
          },
          child: Text("cancel"),
        ),
        TextButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => LoadingDialog());
            DB()
                .workspaces
                .createBook(
                  store.workspace.currentId.value,
                  name.value,
                  summary.value,
                  public.value,
                )
                .then((value) {
              dismiss(context);
            }).whenComplete(() => dismiss(context));
          },
          child: Text("create"),
        ),
      ],
    );
  }

  void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
