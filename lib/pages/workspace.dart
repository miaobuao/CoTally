import 'package:cotally/component/button.dart';
import 'package:cotally/component/dialog.dart';
import 'package:cotally/component/future.dart';
import 'package:cotally/component/header.dart';
import 'package:cotally/component/icons.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/style/colors.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/datetime.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final store = Store();

// ignore: must_be_immutable
class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceId = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.appName),
      ),
      drawer: const WorkspaceDrawer(),
      body: const WorkspaceBody(),
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

class WorkspaceBody extends StatefulWidget {
  const WorkspaceBody({super.key});

  @override
  State<WorkspaceBody> createState() => _WorkspaceBodyState();
}

class _WorkspaceBodyState extends State<WorkspaceBody> {
  final db = DB();
  WorkspaceModel? workspace;
  bool loading = false;
  List<BookModel> books = [];
  late final workspaceId;

  @override
  void initState() {
    super.initState();
    loading = true;
    workspaceId = Get.arguments as String;
    db.workspaces.open(workspaceId).then((value) {
      if (value == null) {
        return;
      }
      workspace = value;
      books = value.books;
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      } else {
        loading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingDialog();
    }
    return RefreshIndicator(
        onRefresh: () async {
          workspace = await db.workspaces.updateBooksOf(workspaceId);
          setState(() {
            books = workspace!.books;
          });
        },
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            final book = books[index];
            Widget child;
            if (db.fs.getBookDir(workspace!.org, books[index]).existsSync()) {
              child = ListTile(
                title: Text("${book.namespace}/${book.name}"),
                // subtitle: Text(book.summary ?? ''),
                onTap: () {
                  print("taptap");
                },
              );
            } else {
              child = ListTile(
                enabled: false,
                title: Text("${book.namespace}/${book.name}"),
              );
            }
            return Dismissible(
              background: Container(
                color: dangerColor,
              ),
              key: UniqueKey(),
              child: child,
              onDismissed: (DismissDirection direction) {
                books.remove(book);
              },
            );
          },
        ));
  }
}

class WorkspaceDrawer extends StatefulWidget {
  const WorkspaceDrawer({super.key});

  @override
  State<WorkspaceDrawer> createState() => _WorkspaceDrawerState();
}

class _WorkspaceDrawerState extends State<WorkspaceDrawer> {
  List<WorkspaceInfo> list = [];

  @override
  void initState() {
    super.initState();
    DB().workspaces.list.then((value) {
      setState(() {
        list = value
            .map((e) => WorkspaceInfo(
                  id: e.id,
                  org: e.org,
                ))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, idx) {
            return ListTile(
              title: FutureText(
                future: list[idx].owner.then((value) => value!.info.name),
                width: 100,
              ),
              subtitle: FutureText(
                future: list[idx].updateTime.then(timeFormat),
                width: 100,
              ),
              leading: Icon(GitAppIconData.of(list[idx].org)),
              onTap: () {},
            );
          }),
    );
  }
}

class WorkspaceInfo {
  final String id;
  final Org org;
  final db = DB();
  WorkspaceInfo({
    required this.id,
    required this.org,
  });

  Future<EncryptedRemoteRepoDataModel?> get repo {
    return db.remoteRepo.get(id);
  }

  Future<UserModel?> get owner {
    return repo.then((value) => db.users.get(value!.ownerId));
  }

  Future<DateTime> get updateTime {
    return repo.then((value) => value!.updateTime);
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
