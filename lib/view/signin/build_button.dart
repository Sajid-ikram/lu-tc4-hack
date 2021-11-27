import 'package:flutter/material.dart';

Stack buildButton(
    IconData icon, String text, double a, Size size, Color color) {
  return Stack(
    children: [
      icon == Icons.cancel
          ? const SizedBox()
          : Positioned(
        left: 10,
        top: 15,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Icon(
            icon,
            size: a,
            color: color,
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: color == Colors.white ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
