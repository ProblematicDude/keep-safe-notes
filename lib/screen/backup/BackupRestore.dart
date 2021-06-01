import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilities.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper({Key? key}) : super(key: key);

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  double padding = 150;
  double bottomPadding = 0;

  @override
  Widget build(BuildContext context) => Align(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  Language.of(context).backupWarning,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline5!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                onPressed: () async {
                  final items =
                      await Provider.of<NotesHelper>(context, listen: false)
                          .getNotesAllForBackupHelper();
                  if (items.isNotEmpty) {
                    unawaited(
                      exportToFile(items).then(
                        (value) {
                          if (value) {
                            Utilities.showSnackbar(
                              context,
                              Language.of(context).done,
                            );
                          } else {
                            Utilities.showSnackbar(
                              context,
                              Language.of(context).error,
                            );
                          }
                        },
                      ),
                    );
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).backupScheduled,
                    );
                  } else {
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).done,
                    );
                  }
                },
                child: Text(
                  Language.of(context).exportNotes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Utilities.requestPermission(Permission.storage)) {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    File file;
                    if (result != null) {
                      file = File(result.files.single.path!);
                      await importFromFile(file);
                    }
                  } else {
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).permissionError,
                    );
                  }
                },
                child: Text(
                  Language.of(context).importNotes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> exportToFile(List<dynamic> items) async {
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        final str = DateFormat('yyyyMMdd_HHmmss').format(
          DateTime.now(),
        );
        final fileName = 'Export_$str.json';
        const folderName = '/${Utilities.appName}/';
        final path =
            Provider.of<LockChecker>(context, listen: false).exportPath;
        final finalPath = path + folderName + fileName;
        try {
          await File(finalPath).create(recursive: true);
        } on Exception catch (e) {
          debugPrint(e.toString());
          return false;
        }
        final file = File(finalPath);
        final jsonList = [];

        for (final Note note in items) {
          jsonList.add(json.encode(note.toJson()));
        }
        file.writeAsStringSync(
          jsonList.toString(),
        );
      }else{
        debugPrint('Permission Error'); // TODO Permission Error
      }
    } on Exception catch (e) {
      debugPrint(e.toString());

      return false;
    }
    return true;
  }

  Future<void> importFromFile(File file) async {
    try {
      final stringContent = file.readAsStringSync();
      final List jsonList = json.decode(stringContent);
      final notesList = jsonList
          .map(
            (json) => Note.fromJson(json),
          )
          .toList();
      await Provider.of<NotesHelper>(context, listen: false)
          .addAllNotesToDatabaseHelper(notesList);
      Utilities.showSnackbar(
        context,
        Language.of(context).done,
      );
    } on Exception catch (_) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }
}
