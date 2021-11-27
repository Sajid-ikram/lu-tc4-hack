import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SizedBox textField(IconData iconData, String hint, Color color, String text) {
  return SizedBox(
    height: 55,
    child: TextFormField(
      style: const TextStyle(color: Colors.grey, fontSize: 13),
      initialValue: text,

      textAlign: TextAlign.start,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(30, 5, 0, 0),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Icon(
            iconData,
            size: 18,
            color: Colors.grey,
          ),
        ),
        filled: true,
        fillColor: color,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey,),


      ),
    ),
  );
}
