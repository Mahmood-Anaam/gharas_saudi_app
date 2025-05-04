import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../core/widgets/header.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Point? selectedLocation = Point(coordinates: Position(46.6753, 24.7136));

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Header(
            title: 'Select Location',
            subtitle: 'Choose your planting area',
            showLogoutButton: true,
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MapWidget(
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    cameraOptions: CameraOptions(
                      center: selectedLocation!,
                      zoom: 3,
                      bearing: 0,
                      pitch: 0,
                    ),
                    onMapCreated: _onMapCreated,
                    onTapListener: (MapContentGestureContext map) {
                      setState(() async {
                        await pointAnnotationManager?.deleteAll();
                        selectedLocation = map.point;
                        await _createAnnotation(selectedLocation!);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            width: SizeConfig.screenWidth! * 0.9,
            onPressed: _fetchRecommendedPlants,
            isLoading: _isLoading,
            text: 'Confirm Location',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
        await this.mapboxMap.annotations.createPointAnnotationManager();
    await _createAnnotation(selectedLocation!);
  }

  Future<void> _createAnnotation(Point point) async {
    await pointAnnotationManager?.deleteAll();
    final ByteData bytes = await rootBundle.load(
      'assets/images/custom-icon.png',
    );
    final Uint8List imageData = bytes.buffer.asUint8List();
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(point.coordinates.lng, point.coordinates.lat),
      ),
      image: imageData,
      iconSize: 2.0,
    );
    await pointAnnotationManager?.create(pointAnnotationOptions);
  }

  Future<void> _fetchRecommendedPlants() async {
    if (selectedLocation == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recommend'),
        body: jsonEncode({
          'lat': selectedLocation!.coordinates.lat,
          'lon': selectedLocation!.coordinates.lng,
          'limit': 3,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final plants = data['recommendations']! as List<dynamic>;
        final weather = data['weather']! as Map<String, dynamic>;

        if (mounted) {
          context.pushNamed(
            AppRoute.weatherCharacteristics.name,
            extra: {'plants': plants, 'weather': weather},
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get recommendations'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
