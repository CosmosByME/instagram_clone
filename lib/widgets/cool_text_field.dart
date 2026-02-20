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

class CoolTextFieldForPassword extends StatefulWidget {
  final bool isVisible;
  final String hintText;
  final TextEditingController controller;
  const CoolTextFieldForPassword({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isVisible,
  });

  @override
  State<CoolTextFieldForPassword> createState() =>
      _CoolTextFieldForPasswordState();
}

class _CoolTextFieldForPasswordState extends State<CoolTextFieldForPassword> {
  late bool isVisible;
  @override
  void initState() {
    super.initState();
    isVisible = widget.isVisible;
  }

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
        obscureText: !isVisible,
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          isDense: true, 
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 17, color: Colors.white54),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon: isVisible
                ? Icon(Icons.visibility_off, size: 24,)
                : Icon(Icons.visibility, size: 24),
          ),
        ),
      ),
    );
  }
}
