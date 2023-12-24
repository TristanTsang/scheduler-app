import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  String text;
  Tag({required this.text}) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.deepPurple
        ),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3), child: Text(text, style: const TextStyle(fontSize:12.5, color: Colors.white),)),
      ),
    );
  }
}
