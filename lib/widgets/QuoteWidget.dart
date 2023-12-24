import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({Key? key}) : super(key: key);
  static const List<String> quotes = <String>[
    "\"The most amazing quality a person can have is to be human their whole life\"",
    "\"Don't explain a philosophy\nembrace it\"\n\nEpictetus",
    "\"Dwell on the beauty of life. Watch the stars, and see yourself running with them\"\n\nMarcus Aurelius",
    "\"It is better to live in your own destiny imperfectly than to live somebody else's life with perfection\"\n\nBhagavad Gita",
    "\"The people who are crazy enough to think they can change the world, are the ones who do\"\n\nSteve Jobs",
    "\"If today were the last day of your life, would you want to do what you are about to do today?\"\n\nSteve Jobs",
    "\"Have the courage to follow your heart and intuition. They somehow already know what you truly want.\"\n\nSteve Jobs",
    "\"Learn from yesterday.\nLive for today.\nHope for tomorrow\"\n\nAlbert Einstein",
    "\"If my mind can conceive it.\nAnd my heart can believe it.\nThen I can achieve it.\"\n\nMuhammad Ali",
    "\"Let all that you do be done in love.\"\n\n1 Corinthians 16:14",
    "\"The best way to create your future is to create it\"\n\nAbraham Lincoln",
    "\"Settle on the type of person you want to be and stick to it, whether alone or in company.\"\n\nMarcus Aurelius",
    "\"Give yourself a gift, the present moment.\"\n\nMarcus Aurelius",
    "\"meh, close enough\"\n\nMediocrates",

    "\"Never let the future disturb you. You will meet it, if you have to, with the same weapons of reason which today arm you against the present.\"\n\nMarcus Aurelius",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(

      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 225,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:25, vertical: 20),
          child: Center(
            child: Text(
                textAlign: TextAlign.center,
              quotes[Random().nextInt(quotes.length)],
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ),
    );
  }
}
