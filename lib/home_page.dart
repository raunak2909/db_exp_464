import 'package:db_exp_464/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  void addNoteFromUI() async {
    //DbHelper dbHelper = DbHelper.getInstance();
    bool check = await dbHelper!.addNote(
      title: titleController.text,
      desc: descController.text,
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
  void initState() {
    super.initState();
    fetchNoteFromUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: mNotes.isNotEmpty
          ? ListView.builder(
              itemCount: mNotes.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mNotes[index][DbHelper.COLUMN_NOTE_TITLE],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(mNotes[index][DbHelper.COLUMN_NOTE_DESC]),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('No Notes yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                padding: EdgeInsets.all(11),
                child: Column(
                  children: [
                    Text(
                      "Add Note",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                          onPressed: () {
                            addNoteFromUI();
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
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
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
