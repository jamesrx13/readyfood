import 'package:flutter/material.dart';

class CustomOutLineButton extends StatelessWidget {
  const CustomOutLineButton(
      {Key? key,
      required this.content,
      required this.color,
      required this.onPressed})
      : super(key: key);
  final String content;
  final Color color;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return OutlineButton(
      borderSide: BorderSide(color: color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      onPressed: onPressed,
      color: color,
      textColor: color,
      child: SizedBox(
        height: 50.0,
        child: Center(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );
  }
}
