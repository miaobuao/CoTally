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
import 'package:cotally/utils/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

final store = Store();

// ignore: must_be_immutable
class WorkspacePage extends StatelessWidget {
  final db = DB();
  final books = RxList<BookModel>([]);
  final loading = false.obs;
  WorkspaceModel? workspace;
  WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceId = Get.arguments as String;
    loading.value = true;
    db.workspaces.open(workspaceId).then((value) {
      if (value == null) {
        return;
      }
      workspace = value;
      books.value = value.books;
    }).whenComplete(() {
      loading.value = false;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.appName),
      ),
      drawer: const WorkspaceDrawer(),
      // drawer: Drawer(
      //   child: Obx(() => ListView.builder(
      //       itemCount: store.workspace.count.value,
      //       itemBuilder: (context, idx) {
      //         final data = db.remoteRepo.getByIndex(idx);
      //         final owner = db.users.get(data.ownerId);
      //         return FutureBuilder(
      //           future: owner,
      //           builder: (context, snapshot) {
      //             return Skeletonizer(
      //               enabled: isWaiting(snapshot.connectionState),
      //               child: ListTile(
      //                 title: Text(snapshot.data?.info.name ?? ''),
      //                 subtitle: Text(timeFormat(data.updateTime)),
      //                 leading: Icon(GitAppIconData.of(snapshot.data?.org)),
      //                 onTap: () {},
      //               ),
      //             );
      //           },
      //         );
      //       })),
      // ),
      body: RefreshIndicator(
          onRefresh: () async {
            workspace = await db.workspaces.updateBooksOf(workspaceId);
            books.value = workspace!.books;
          },
          child: Obx(() => loading.value
              ? LoadingDialog()
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final book = books[index];
                    Widget child;
                    // if (!db.fs.getBookDir(workspace!.org, book).existsSync()) {

                    child = ListTile(
                      title: Text("${book.namespace}/${book.name}"),
                      subtitle: Text(book.summary ?? ''),
                      onTap: () {
                        print("taptap");
                      },
                    );
                    // TODO: 把body整个写成stateful widget
                    return Dismissible(
                      key: Key('$index'),
                      child: child,
                      onDismissed: (DismissDirection direction) {
                        books.remove(book);
                      },
                    );
                  },
                ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CreateRepoDialog(
                  workspaceId: workspaceId,
                );
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

class WorkspaceDrawer extends StatefulWidget {
  const WorkspaceDrawer({super.key});

  @override
  State<WorkspaceDrawer> createState() => _WorkspaceDrawerState();
}

class _WorkspaceDrawerState extends State<WorkspaceDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}

class CreateRepoDialog extends StatelessWidget {
  final name = "".obs;
  final summary = "".obs;
  final org = Org.gitee.obs;
  final public = true.obs;
  final String workspaceId;
  CreateRepoDialog({super.key, required this.workspaceId});

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
              "aaa",
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
                  workspaceId,
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
