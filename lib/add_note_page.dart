import 'package:db_exp_464/db_helper.dart';
import 'package:flutter/material.dart';

import 'note_model.dart';

class AddNotePage extends StatefulWidget {
  bool isUpdate;
  int? mId;
  String mTitle;
  String mDesc;

  AddNotePage({
    this.isUpdate = false,
    this.mId,
    this.mTitle = '',
    this.mDesc = '',
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
    titleController.text = widget.mTitle;
    descController.text = widget.mDesc;
  }

  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  DbHelper? dbHelper;

  List<NoteModel> mNotes = [];

  void addNoteFromUI() async {
    //DbHelper dbHelper = DbHelper.getInstance();
    bool check = await dbHelper!.addNote(
        newNote: NoteModel(
            title: titleController.text,
            desc: descController.text,
            createdAt: DateTime.now().millisecondsSinceEpoch)
    );
    if (check) {
      fetchNoteFromUI();
    }
  }

  void fetchNoteFromUI() async {
    dbHelper = DbHelper.getInstance();
    mNotes = await dbHelper!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.isUpdate ? "Update" : "Add"} Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          children: [
            SizedBox(height: 11),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter your title here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Description",
                hintText: "Enter your desc here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    if (widget.isUpdate) {
                      bool isUpdated = await dbHelper!.updateNote(
                        title: titleController.text,
                        desc: descController.text,
                        id: widget.mId ?? 0,
                      );

                      if (isUpdated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Note updated successfully!!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        fetchNoteFromUI();
                      }
                    } else {
                      addNoteFromUI();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(widget.isUpdate ? 'Update' : 'Add'),
                ),
                SizedBox(width: 11),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
