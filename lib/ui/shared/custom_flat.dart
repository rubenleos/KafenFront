import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final bool isFilled;

  const CustomFlatButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.isFilled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      
      style: TextButton.styleFrom(
      
        backgroundColor: isFilled ? color : Colors.transparent,
      
       
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      onPressed: () => onPressed(),
      child: Text(text),
    );
  }
}