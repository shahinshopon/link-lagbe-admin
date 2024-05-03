
import 'package:flutter/material.dart';

Widget customButton(
  String title,
  onPressed,
) {
  return Container(
    height: 45,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: Colors.amber,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        ),
      ),
    ),
  );
}