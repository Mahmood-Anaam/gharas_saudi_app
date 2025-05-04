import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenHeight! * 0.13,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            bottom: -20,
            left: 0,
            child: Image.asset('assets/images/footer_tree.png'),
          ),
        ],
      ),
    );
  }
}
