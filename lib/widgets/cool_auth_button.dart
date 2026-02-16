import 'package:flutter/material.dart';

class CoolAuthButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  const CoolAuthButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<CoolAuthButton> createState() => _CoolAuthButtonState();
}

class _CoolAuthButtonState extends State<CoolAuthButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCAF45), Color(0xFFF56040)],
            begin: AlignmentGeometry.topRight,
            end: AlignmentGeometry.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
