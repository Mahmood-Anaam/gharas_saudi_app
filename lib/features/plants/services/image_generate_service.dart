import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';

class ImageGenerateResult {
  final bool success;
  final String? imageUrl;
  final String message;

  ImageGenerateResult({
    required this.success,
    this.imageUrl,
    required this.message,
  });
}

class ImageGenerateService {
  static Future<ImageGenerateResult> generatePlantImage(
    String plantName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-plant-image?plant_name=$plantName'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ImageGenerateResult(
          success: true,
          imageUrl: data['image'],
          message: 'Image generated successfully',
        );
      } else {
        return ImageGenerateResult(
          success: false,
          message: 'Failed to generate image: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ImageGenerateResult(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }

  static Future<List<ImageGenerateResult>> generateMultiplePlantImages(
    List<String> plantNames,
  ) async {
    List<ImageGenerateResult> results = [];
    for (final name in plantNames) {
      results.add(await generatePlantImage(name));
    }

    return results;
  }

  static Future<ImageGenerateResult> generatePlantSimulation({
    required String plantImageUrl,
    required XFile environmentImage,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/generate-plant-simulation'),
      );

      if (plantImageUrl.startsWith('http')) {
        final imageResponse = await http.get(Uri.parse(plantImageUrl));
        request.files.add(
          http.MultipartFile.fromBytes(
            'plant_image',
            imageResponse.bodyBytes,
            filename: 'plant.jpg',
          ),
        );
      } else {
        final bytes = base64Decode(plantImageUrl.split(',').last);
        request.files.add(
          http.MultipartFile.fromBytes(
            'plant_image',
            bytes,
            filename: 'plant.jpg',
          ),
        );
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'environment_image',
          environmentImage.path,
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return ImageGenerateResult(
          success: true,
          imageUrl: data['image'],
          message: 'Simulation generated successfully',
        );
      } else {
        return ImageGenerateResult(
          success: false,
          message: 'Failed to generate simulation: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ImageGenerateResult(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
