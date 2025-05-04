import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'package:go_router/go_router.dart';

class PlantPreviewView extends StatefulWidget {
  final Map<String, dynamic> plant;
  final String? imageUrl;
  const PlantPreviewView({super.key, required this.plant, this.imageUrl});

  @override
  State<PlantPreviewView> createState() => _PlantPreviewViewState();
}

class _PlantPreviewViewState extends State<PlantPreviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(title: 'Plant Preview', subtitle: widget.plant['name']),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 400 ? 32 : 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFD1D8C9),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleAvatar(
                            radius: constraints.maxWidth > 400 ? 55 : 45,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: _buildPlantImage(widget.imageUrl),
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Icon(Icons.schedule, color: kPrimary, size: 28),
                          const SizedBox(height: 8),
                          const Text(
                            'Time for growth',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 40,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: kGradient,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '6-12 months',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Icon(
                            Icons.attach_money,
                            color: kPrimary,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cost per one plant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 40,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: kGradient,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '5-30 Riyal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  width: SizeConfig.screenWidth! * 0.9,
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.imagePicker.name,
                      extra: {
                        'plant': widget.plant,
                        'imageUrl': widget.imageUrl,
                      },
                    );
                  },
                  text: 'Virtual Photo',
                ),

                const Footer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlantImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset("assets/images/sample_plant.png", fit: BoxFit.cover);
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return Image.memory(bytes, fit: BoxFit.cover, width: 110, height: 110);
      } catch (e) {
        return Image.asset("assets/images/sample_plant.png", fit: BoxFit.cover);
      }
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/sample_plant.png",
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
