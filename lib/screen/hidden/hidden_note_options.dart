import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class HiddenNoteOptions extends StatefulWidget {
  const HiddenNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HiddenNoteOptionsState createState() => _HiddenNoteOptionsState();
}

class _HiddenNoteOptionsState extends State<HiddenNoteOptions> {
  @override
  Widget build(final BuildContext context) => Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).options),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ModalSheetWidget(
                      onTap: () async {
                        await onModalTrashTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      icon: Icons.drive_file_move_outline,
                      label: Language.of(context).unhide,
                    ),
                    ModalSheetWidget(
                      onTap: () {
                        onModalArchiveTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).archive,
                      icon: Icons.archive_outlined,
                    ),
                    ModalSheetWidget(
                      icon: TablerIcons.copy,
                      onTap: () {
                        onModalCopyToClipboardTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).clipboard,
                    ),
                    ModalSheetWidget(
                      icon: Icons.delete_outlined,
                      onTap: () async {
                        await onModalTrashTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).delete,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
}
