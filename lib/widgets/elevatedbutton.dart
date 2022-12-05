import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ElevateButton extends StatelessWidget {
  ElevateButton(
      {super.key,
      required this.innertext,
      required this.innercolor,
      this.onTapped});

  String innertext;
  Color innercolor;
  final void Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: innercolor,
        ),
        onPressed: onTapped,
        child: Text(
          innertext,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
