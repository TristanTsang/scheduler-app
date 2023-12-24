import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/sqlite_service.dart';
import '../constants.dart';
import '../Providers/JournalData.dart';
import '../models/JournalPrompt.dart';

class EditJournalScreen extends StatefulWidget {
  JournalPrompt prompt;
  EditJournalScreen({Key? key, required JournalPrompt this.prompt}) : super(key: key);

  @override
  State<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
              TextEditingController(text: widget.prompt.text),
              style: secondaryHeader,
              decoration: InputDecoration(
                  hintText: "Journal Prompt",
                  hintStyle: secondarySubtitle,
                  border: InputBorder.none),
              maxLines: 1,
              autofocus: true,
              onChanged: (value) {
                text = value;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [SizedBox(width:10),Expanded(
                child: RawMaterialButton(

                  onPressed: () {
                    Provider.of<JournalData>(context, listen:false).journalPrompts.remove(widget.prompt);
                    Provider.of<JournalData>(context, listen:false).updateJournal();
                      Navigator.pop(context);
                    },
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            "Delete Prompt",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )),
                ),
              ),
                SizedBox(width:15),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                        if(text !=null){
                          Provider.of<JournalData>(context, listen:false).journalPrompts[Provider.of<JournalData>(context, listen:false).journalPrompts.indexOf(widget.prompt)].text= text!;
                          SqliteService.deletePrompt(widget.prompt);
                          Provider.of<JournalData>(context, listen:false).updateJournal();
                        }
                        Navigator.pop(context);
                      },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black,
                          ),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )),
                  ),
                ),SizedBox(width:10),]
            ),
          ],
        ),
      ),
    );
  }
}
