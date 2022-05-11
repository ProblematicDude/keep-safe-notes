import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

abstract class ModalSheetWidgets extends StatelessWidget {
  const ModalSheetWidgets({
    required this.onTap,
    required this.icon,
    required this.label,
    final Key? key,
  }) : super(key: key);
  final Function()? onTap;
  final IconData icon;
  final String label;
}

class ModalSheetWidget extends ModalSheetWidgets {
  const ModalSheetWidget({
    required final Function()? onTap,
    required final IconData icon,
    required final String label,
    final Key? key,
  }) : super(key: key, onTap: onTap, icon: icon, label: label);

  @override
  Widget build(final BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 35,
                ),
                const SizedBox(width: 16),
                Text(label),
              ],
            ),
          ),
        ),
      );
}

class ModalSheetDeleteAllWidget extends StatefulWidget {
  const ModalSheetDeleteAllWidget({
    final Key? key,
  }) : super(key: key);

  @override
  State<ModalSheetDeleteAllWidget> createState() =>
      _ModalSheetDeleteAllWidgetState();
}

class _ModalSheetDeleteAllWidgetState extends State<ModalSheetDeleteAllWidget> {
  @override
  Widget build(final BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () async {
            final status = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (final context) => MyAlertDialog(
                    content: Text(
                      Language.of(context).emptyTrashWarning,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          Language.of(context).alertDialogOp1,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          Language.of(context).alertDialogOp2,
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (status) {
              if (!mounted) {
                return;
              }
              if (Provider.of<NotesHelper>(context, listen: false)
                  .mainNotes
                  .isNotEmpty) {
                Provider.of<NotesHelper>(context, listen: false).emptyTrash();
              }
            }
            if (!mounted) {
              return;
            }
            Navigator.of(context).popUntil(
              ModalRoute.withName(AppRoutes.trashScreen),
            );
          },
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  TablerIcons.trash,
                  size: 36,
                ),
                const SizedBox(width: 16),
                Text(
                  Language.of(context).emptyTrash,
                ),
              ],
            ),
          ),
        ),
      );
}

class CopyToClipBoardModelSheetWidget extends StatelessWidget {
  const CopyToClipBoardModelSheetWidget(
    this.autoSaver,
    this.saveNote,
    this.note, {
    final Key? key,
  }) : super(key: key);
  final Timer autoSaver;
  final Function() saveNote;
  final Note note;

  @override
  Widget build(final BuildContext context) {
    return ModalSheetWidget(
      icon: TablerIcons.copy,
      onTap: () {
        autoSaver.cancel();
        saveNote();
        Navigator.of(context).pop();
        unawaited(
          Clipboard.setData(
            ClipboardData(text: note.title),
          ).then((final _) {
            Clipboard.setData(
              ClipboardData(text: note.content),
            ).then(
              (final value) => showSnackbar(
                context,
                Language.of(context).done,
                snackBarBehavior: SnackBarBehavior.floating,
              ),
            );
          }),
        );
      },
      label: Language.of(context).clipboard,
    );
  }
}
