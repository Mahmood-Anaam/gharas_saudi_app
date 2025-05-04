import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'package:go_router/go_router.dart';

class WeatherCharacteristicsView extends StatelessWidget {
  final Map<String, dynamic> weather;
  final List<dynamic> plants;

  const WeatherCharacteristicsView({
    super.key,
    required this.weather,
    required this.plants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Header(title: 'Weather', subtitle: 'Characteristics'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherGrid(context),
                  const SizedBox(height: 8),
                  CustomButton(
                    width: SizeConfig.screenWidth! * 0.9,
                    onPressed: () {
                      context.pushNamed(
                        AppRoute.plantSelection.name,
                        extra: {'plants': plants},
                      );
                    },
                    text: 'View Recommended Plants',
                  ),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildWeatherGrid(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1,
      children: [
        _buildWeatherCard(
          context,
          icon: Icons.thermostat,
          title: 'Temperature',
          value: '${weather['temp']}°C',
        ),
        _buildWeatherCard(
          context,
          icon: Icons.water_drop,
          title: 'Humidity',
          value: '${weather['humidity']}%',
        ),
        _buildWeatherCard(
          context,
          icon: Icons.location_on,
          title: 'Region',
          value: weather['region'],
        ),
        _buildWeatherCard(
          context,
          icon: Icons.landscape,
          title: 'Soil Type',
          value: _getSoilTypeDisplay(weather['soil']),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF6A8D73)),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: const Color(0xFF6A8D73),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value.trim().isEmpty ? 'Unknown' : value,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getSoilTypeDisplay(dynamic soilType) {
    if (soilType is String) return soilType;
    if (soilType is Map && soilType['name'] != null) return soilType['name'];
    return 'Not specified';
  }
}
