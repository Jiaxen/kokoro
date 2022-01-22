import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/models/note.dart';
import 'package:kokoro/services/note_services.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'notes_screen.dart';

class EditNoteScreen extends StatefulWidget {
  Note note;

  EditNoteScreen({Key? key, required this.note});


  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
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
    return SingleChildScrollView(
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        backgroundColor: kPrimaryBackgroundColour,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        content: Container(
          width: double.maxFinite,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'A note of...',
                  style: TextStyle(
                      color: kPrimaryTextColour,
                      fontWeight: FontWeight.w300, // light
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
                SizedBox(height: 10),
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
                    print(newValue);
                    setState(() {
                      widget.note.noteType = enumFromString(NoteType.values, newValue!)!;
                      dropdownValue = newValue;
                    });
                  },
                  items: noteTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                    controller: myController,
                    autofocus: true,
                    decoration: InputDecoration(
                      focusColor: kPrimaryAppColour,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kSecondaryAppColour, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      hintText: 'Note for your meeting...',
                    ),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 5,
                    maxLines: 10),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(15)),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(kWarningBackgroundColorLight),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(kPrimaryTitleColour),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          )),
                    ),
                    onPressed: () {
                      if (myController.text.isEmpty && widget.note.id == null){ // If it is empty and a new note
                        Navigator.of(context).pop();
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete Note?'),
                            content: const Text('Are you sure you want to delete this note?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('No, go back!'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteNoteFromFireStore(widget.note);
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                child: const Text('Yes please!'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text('Delete'),
                  ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryAppColour),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryTitleColour),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        )),
                      ),
                      onPressed: () {
                          if (myController.text.isNotEmpty){
                            widget.note.content = myController.text;
                            widget.note.lastModifiedTime = DateTime.now();
                            saveNoteToFireStore(widget.note, widget.note.groupId);
                          }
                        Navigator.pop(context);
                      },
                      child: Text('Save note'),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}