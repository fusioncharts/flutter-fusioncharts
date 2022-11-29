


import 'package:flutter/material.dart';




class PrimaryButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String title;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final bool expanded;
  final double? width;
  final double? elevation;
  final Widget? icon;
  final Color? titleColor;

  const PrimaryButton({Key? key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.color,
    this.borderColor,
    this.expanded=true,
    this.width,
    this.elevation,
    this.icon,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?? (expanded?double.infinity:width),
      child: TextButton(
          style: TextButton.styleFrom(
              elevation: elevation??0,
              shape:  RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: borderColor??color??Colors.black)
              ),
              padding: padding??  const EdgeInsets.all(20),
              backgroundColor: color??Colors.blue,
              foregroundColor: Colors.black
          ),
          onPressed:
          onPressed,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              icon==null?Container():Padding(
                padding: const EdgeInsets.fromLTRB(0,0,5,0,),
                child: icon,
              ),
              Center(
                child: Text(title,
                  style: TextStyle(
                    color: Colors.white
                  ),),
              ),
            ],
          )),
    );
  }
}
