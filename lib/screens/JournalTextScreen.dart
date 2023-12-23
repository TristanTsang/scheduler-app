import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Providers/AppData.dart';
import '../Providers/JournalData.dart';
import '../constants.dart';
import '../models/journalEntry.dart';

class JournalTextScreen extends StatefulWidget {
  DateTime date;

  JournalEntry journal;
  JournalTextScreen({Key? key, required this.date, required this.journal}) : super(key: key);

  @override
  State<JournalTextScreen> createState() => _JournalTextScreenState();
}

class _JournalTextScreenState extends State<JournalTextScreen> {



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  late QuillController _controller;
  Widget build(BuildContext context) {
    DateTime selectedDate = widget.date;


    _controller.document = Document.fromJson(jsonDecode(widget.journal.getFile()));
    _controller.document.changes.listen((event) {
      widget.journal.editFile(jsonEncode(_controller.document.toDelta().toJson()));
      SqliteService.updateJournal(widget.journal, DateTimeExtensions.stringFormat(selectedDate));
    });
    return QuillProvider(
      configurations: QuillConfigurations(controller: _controller),
      child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                titleSpacing: 0,
                leadingWidth: 45,
                title: Text("journal entry: ${DateFormat.yMMMMd('en_US').format(selectedDate).toLowerCase()}", style: TextStyle(fontSize: 17.5),),
                leading: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            backgroundColor: Colors.black,
            body: Container(

              child: ListView(

                shrinkWrap: true,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "journal entry:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
                                  ),

                                  SizedBox(height:10),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: kLightGrey,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: MediaQuery.sizeOf(context).height * 0.075,
                                    width: MediaQuery.sizeOf(context).width,

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${DateFormat.yMMMMd('en_US').format(selectedDate).toLowerCase()}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Divider(thickness: 1,),
                                  SizedBox(height: 15,),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        readOnly: false,

                                      ).copyWith(
                                        scrollable: false,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
    );
  }
}
