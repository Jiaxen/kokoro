import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/routing/app_router.dart';
import 'package:kokoro/utils.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final Note note;
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);


  static Future<void> show(BuildContext context, {Note? note}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.editNoteScreen,
      arguments: note,
    );
  }

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  String? dropdownValue;
  final myController = TextEditingController();

  @override
  void initState() {
    dropdownValue = enumToCapitalisedString(widget.note.noteType);
    myController.text = widget.note.content; // If note already has content
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          backgroundColor: kPrimaryBackgroundColour,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'A note of...',
                    style: TextStyle(
                        color: kPrimaryTextColour,
                        fontWeight: FontWeight.w300, // light
                        fontStyle: FontStyle.italic,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: dropdownValue,
                    // icon: const Icon(Icons.a),
                    elevation: 2,
                    style: TextStyle(
                      color: kPrimaryTextColour,
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                    ),
                    dropdownColor: kTextBackgroundColour,
                    underline: Container(
                      height: 2,
                      color: kPrimaryAppColour,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.note.noteType =
                            enumFromString(NoteType.values, newValue!)!;
                        dropdownValue = newValue;
                      });
                    },
                    items:
                        noteTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      controller: myController,
                      autofocus: true,
                      decoration: InputDecoration(
                        focusColor: kPrimaryAppColour,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kSecondaryAppColour, width: 2.0),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Note for your meeting...',
                      ),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 3,
                      maxLines: 3),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: roundButtonStyle(kPrimaryTitleColour, kWarningBackgroundColorLight),
                        onPressed: () {
                          if (myController.text.isEmpty &&
                              widget.note.id == null) {
                            // If it is empty and a new note
                            Navigator.of(context).pop();
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                insetPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25))),
                                title: const Text('Delete Note?'),
                                content: const Text(
                                    'This will delete the note forever.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final database = ref.watch(databaseProvider)!;
                                      database.deleteNote(widget.note);
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                    child: const Text('DELETE'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        style: roundButtonStyle(kPrimaryTitleColour, kPrimaryAppColour),
                        onPressed: () {
                          if (myController.text.isNotEmpty) {
                            widget.note.content = myController.text;
                            widget.note.lastModifiedTime = DateTime.now();
                            final database = ref.watch(databaseProvider)!;
                            database.setNote(widget.note);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Save note'),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
