import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
  });
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        width: width ?? SizeConfig.screenWidth! * 0.7,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[Color(0xFF6A8D73), Color(0xFF9CE0B2)],
          ),
        ),
        child:
            isLoading
                ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                  constraints: BoxConstraints.tight(
                    Size(
                      SizeConfig.defaultSize! * 2.5,
                      SizeConfig.defaultSize! * 2.5,
                    ),
                  ),
                )
                : Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.defaultSize! * 1.8,
                  ),
                  text ?? '',
                ),
      ),
    );
  }
}
