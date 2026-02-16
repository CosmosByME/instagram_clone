import 'package:flutter/material.dart';

class CoolTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  const CoolTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<CoolTextField> createState() => _CoolTextFieldState();
}

class _CoolTextFieldState extends State<CoolTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 17, color: Colors.white54),
        ),
      ),
    );
  }
}