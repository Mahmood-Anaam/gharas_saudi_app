import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'package:gharas_saudi_app/features/plants/services/image_generate_service.dart';
import 'package:go_router/go_router.dart';

class PlantSelectionView extends StatefulWidget {
  final List<dynamic> plants;
  const PlantSelectionView({super.key, required this.plants});
  @override
  State<PlantSelectionView> createState() => _PlantSelectionViewState();
}

class _PlantSelectionViewState extends State<PlantSelectionView> {
  final List<ImageGenerateResult> _imagesGenerateCache = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Get all plant names
      final plantNames = widget.plants.map((p) => p['name'] as String).toList();

      // Generate all images at once
      final imagesGenerateResult =
          await ImageGenerateService.generateMultiplePlantImages(plantNames);

      setState(() {
        _imagesGenerateCache.addAll(imagesGenerateResult);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Scaffold(
      body: Column(
        children: [
          const Header(title: 'plant suggestions', subtitle: 'Powered by AI'),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      itemCount: widget.plants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 40),
                      itemBuilder: (_, i) {
                        final plant = widget.plants[i];
                        final imageGenerateResult = _imagesGenerateCache[i];
                        String? imgurl = imageGenerateResult.imageUrl;

                        return _PlantTile(plant: plant, url: imgurl);
                      },
                    ),
          ),
          const Footer(),
        ],
      ),
    ),
  );
}

class _PlantTile extends StatelessWidget {
  final Map<String, dynamic> plant;
  final String? url;
  const _PlantTile({required this.plant, this.url});

  @override
  Widget build(BuildContext ctx) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        // Circular image with ring
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: kGradient,
          ),
          padding: const EdgeInsets.all(6),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: ClipOval(child: _buildPlantImage(url)),
          ),
        ),
        const SizedBox(width: 12),
        // Gradient name pill
        Expanded(
          child: InkWell(
            onTap: () {
              ctx.pushNamed(
                AppRoute.plantPreview.name,
                extra: {'plant': plant, 'imageUrl': url},
              );
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: kGradient,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
              ),
              child: Text(
                '${plant["name"]}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildPlantImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.network(
        "https://m.media-amazon.com/images/I/41zkkbDRApL.__AC_SY300_SX300_QL70_ML2_.jpg",
        fit: BoxFit.cover,
      );
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return Image.memory(bytes, fit: BoxFit.cover, width: 110, height: 110);
      } catch (e) {
        return Image.network(
          "https://m.media-amazon.com/images/I/41zkkbDRApL.__AC_SY300_SX300_QL70_ML2_.jpg",
          fit: BoxFit.cover,
        );
      }
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            "https://m.media-amazon.com/images/I/41zkkbDRApL.__AC_SY300_SX300_QL70_ML2_.jpg",
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
