import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AppData.dart';
import '../constants.dart';
import '../Providers/JournalData.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({Key? key}) : super(key: key);

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
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
            RawMaterialButton(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    height: MediaQuery.of(context).size.height * 0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text(
                        "Add Journal",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                onPressed: () {
                  if(text !=null){
                    Provider.of<JournalData>(context, listen: false).addPrompt(text!);
                    Navigator.pop(context);
                  }

                }),
          ],
        ),
      ),
    );
  }
}
