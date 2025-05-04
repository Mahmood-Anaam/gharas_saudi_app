import 'package:gharas_saudi_app/features/auth/presentation/login_view.dart';
import 'package:gharas_saudi_app/features/auth/presentation/reset_password_view.dart';
import 'package:gharas_saudi_app/features/auth/presentation/signup_view.dart';
import 'package:gharas_saudi_app/features/location/presentation/location_picker_view.dart';
import 'package:gharas_saudi_app/features/plants/presentation/image_picker_view.dart';
import 'package:gharas_saudi_app/features/plants/presentation/plant_preview_view.dart';
import 'package:gharas_saudi_app/features/plants/presentation/plant_selection_view.dart';
import 'package:gharas_saudi_app/features/plants/presentation/virtual_photo_view.dart';
import 'package:gharas_saudi_app/features/splash/presentation/splash_view.dart';
import 'package:gharas_saudi_app/features/weather/presentation/weather_characteristics_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/location-picker',
      name: AppRoute.locationPicker.name,
      builder: (context, state) => const LocationPickerView(),
    ),
    GoRoute(
      path: '/weather-characteristics',
      name: AppRoute.weatherCharacteristics.name,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return WeatherCharacteristicsView(
          plants: extra['plants']! as List<dynamic>,
          weather: extra['weather']! as Map<String, dynamic>,
        );
      },
    ),

    GoRoute(
      path: '/plant-selection',
      name: AppRoute.plantSelection.name,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra! as Map<String, dynamic>;
        return PlantSelectionView(plants: extra['plants']! as List<dynamic>);
      },
    ),

    GoRoute(
      path: '/plant-preview',
      name: AppRoute.plantPreview.name,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return PlantPreviewView(
          plant: extra['plant'] as Map<String, dynamic>,
          imageUrl: extra['imageUrl'] as String?,
        );
      },
    ),

    GoRoute(
      path: '/image-picker',
      name: AppRoute.imagePicker.name,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ImagePickerView(
          plant: extra['plant'] as Map<String, dynamic>,
          imageUrl: extra['imageUrl'] as String?,
        );
      },
    ),

    GoRoute(
      path: '/virtual-photo',
      name: AppRoute.virtualPhoto.name,
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return VirtualPhotoView(
          plantImageUrl: extra['plantImageUrl'] as String,
          environmentImageFile: extra['environmentImageFile'] as XFile,
        );
      },
    ),

    GoRoute(
      path: '/splash',
      name: AppRoute.splash.name,
      builder: (context, state) => const SplashView(),
    ),

    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginView(),
    ),

    GoRoute(
      path: '/signup',
      name: AppRoute.signup.name,
      builder: (context, state) => const SignupView(),
    ),

    GoRoute(
      path: '/resetPassword',
      name: AppRoute.resetPassword.name,
      builder: (context, state) => const ResetPasswordView(),
    ),
  ],
);
