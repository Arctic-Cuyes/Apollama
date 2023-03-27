import 'package:flutter/material.dart';
import 'package:zona_hub/src/styles/global.colors.dart';


class ButtonPrincipal extends StatefulWidget {
  final String text;

  final VoidCallback  onPressed;

  final bool showBorders;

  const ButtonPrincipal({
  Key? key,
  required this.text,
  required this.onPressed,
  this.showBorders = false,
}) : super(key: key);

  @override
  State<ButtonPrincipal> createState() => _ButtonPrincipalState();
}

class _ButtonPrincipalState extends State<ButtonPrincipal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.white,
          backgroundColor: !widget.showBorders ? 
            GlobalColors.blackColor :
            Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          shadowColor: Colors.transparent,

          side: widget.showBorders ? 
            const BorderSide(
              color: GlobalColors.blackColor,
              width: 3.0
            ) : 
            BorderSide.none,

          padding: const EdgeInsets.symmetric(
            vertical: 13.0
          )
  
        ),
        
       
        child: Text(
            widget.text,
            style: TextStyle(
              color: widget.showBorders ? 
                GlobalColors.blackColor : 
                Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            )
          )
      ),
    );
  }
}