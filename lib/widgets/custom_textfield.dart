import 'package:flutter/material.dart';

Widget customFormField(
  controller,
  context,
  hinttext,
  validator) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.always,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        hintText: hinttext,
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}