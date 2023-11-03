import 'package:cotally/component/dialog.dart';
import 'package:cotally/component/future.dart';
import 'package:cotally/component/icons.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/style/colors.dart';
import 'package:cotally/utils/config.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/datetime.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/event_bus.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final store = Store();

late EventBus eventbus;

enum Events {
  updateWorkspace,
}

// ignore: must_be_immutable
class WorkspacePage extends StatelessWidget {
  WorkspacePage({super.key}) {
    eventbus = EventBus();
  }

  @override
  Widget build(BuildContext context) {
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
                  workspaceId: config.lastOpenedId!,
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

  update() {
    db.workspaces.open(config.currentWorkspaceId.value).then((value) {
      if (value == null) return;
      workspace = value;
      books = value.books;
    }).whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    eventbus.listen(Events.updateWorkspace, update);

    loading = true;
    db.workspaces.open(config.currentWorkspaceId.value).then((value) {
      if (value == null) return;
      workspace = value;
      books = value.books;
    }).whenComplete(() {
      loading = false;
      if (mounted) {
        setState(() {});
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
          await db.workspaces.updateBooksOf(config.currentWorkspaceId.value);
          eventbus.emit(Events.updateWorkspace);
        },
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            Widget child;
            final book = books[index];
            bool cached = book.directory.existsSync();
            if (cached) {
              child = ListTile(
                title: Text("${book.namespace}/${book.name}"),
                onTap: () {
                  openBook(context, book);
                },
              );
            } else {
              child = InkWell(
                child: ListTile(
                  enabled: false,
                  title: Text("${book.namespace}/${book.name}"),
                ),
                onTap: () {
                  downloadBook(context, book);
                  // showDialog(context: context, builder: builder)
                },
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
              confirmDismiss: (DismissDirection direction) async {
                return await showRemoveAlertDialog(context, book, cached);
              },
            );
          },
        ));
  }

  openBook(BuildContext context, BookModel book) {}
  downloadBook(BuildContext context, BookModel book) {
    showDialog(context: context, builder: (context) => LoadingDialog());
    db.fs.clone(book).then((value) {
      toast.add(S.current.done, type: ToastType.success);
    }).whenComplete(() => Navigator.pop(context));
  }

  Future<bool> showRemoveAlertDialog(
      BuildContext context, BookModel book, bool cached) async {
    return await showDialog(
        context: context,
        builder: (context) {
          var removeBoth = TextButton(
              onPressed: () {
                Navigator.pop(context, Location.both);
              },
              child: Text(S.current.removeCompletely));
          var removeLocal = TextButton(
              onPressed: () {
                Navigator.pop(context, Location.local);
              },
              child: Text(S.current.removeLocal));

          var cancelButton = TextButton(
              onPressed: () {
                Navigator.pop(context, Location.none);
              },
              child: Text(S.current.cancel));
          return AlertDialog(
            title: Text(S.current.confirmDeletion),
            actions: cached
                ? [
                    cancelButton,
                    removeLocal,
                    removeBoth,
                  ]
                : [
                    cancelButton,
                    removeBoth,
                  ],
          );
        }).then((selected) async {
      if (selected == Location.none) return selected;
      final String msg = selected == Location.both
          ? S.current.removeCompletely
          : S.current.removeLocal;
      return await ReconfirmDialog(
        title: Text(S.current.reconfirm),
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ).show(context).then((value) => value ? selected : Location.none);
    }).then((value) async {
      bool flag = false;
      if (value == Location.none) {
        return false;
      } else if (value == Location.local) {
        db.fs.removeLocal(book).then((value) {
          toast.add(S.current.done, type: ToastType.success);
        }).onError((error, stackTrace) {
          toast.add(S.current.failed, type: ToastType.error);
        });
        flag = true;
      } else if (value == Location.both) {
        db.fs.removeRemote(config.currentWorkspaceId.value, book).then((value) {
          toast.add(S.current.done, type: ToastType.success);
        }).onError((error, stackTrace) {
          toast.add(S.current.failed, type: ToastType.error);
        });
        flag = true;
      } else if (value == Location.remote) {
        throw Exception("`Location` can not be `remote` while deleting");
      }
      if (flag) {
        eventbus.emit(Events.updateWorkspace);
      } else {
        toast.add(S.current.failed, type: ToastType.error);
      }
      return flag;
    });
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

  Future<RemoteRepoDataModel?> get repo {
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
  final accessPwd = "".obs;
  final String workspaceId;
  CreateRepoDialog({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(
      height: 5.5,
    );
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.createBook,
              style: const TextStyle(fontSize: 18),
            ),
            space,
            Input(
              hint: S.current.name,
              value: name,
              autofocus: true,
            ),
            space,
            Input(
              hint: S.current.summary,
              value: summary,
            ),
            space,
            Input(
              obscureText: true,
              value: accessPwd,
              hint: S.current.accessPassword,
            ),
            space,
            Obx(() => SwitchListTile(
                title: Text(S.current.public),
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
          child: Text(S.current.cancel),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => LoadingDialog(),
            );
            db.workspaces
                .createBook(
                    accessPwd: accessPwd.value,
                    workspaceId: workspaceId,
                    name: name.value,
                    summary: summary.value,
                    public: public.value)
                .then((value) {
              dismiss(context);
              eventbus.emit(Events.updateWorkspace);
            }).whenComplete(() => dismiss(context));
          },
          child: Text(S.current.create),
        ),
      ],
    );
  }

  void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
