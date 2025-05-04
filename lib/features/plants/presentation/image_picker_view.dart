import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerView extends StatefulWidget {
  final Map<String, dynamic> plant;
  final String? imageUrl;
  const ImagePickerView({super.key, required this.plant, this.imageUrl});

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  XFile? environmentImageFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _imageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      environmentImageFile = image;
    });
  }

  void _removeImage() {
    setState(() {
      environmentImageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Image Picker',
            subtitle: 'Tap to capture your environment',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Tappable image preview
                  GestureDetector(
                    onTap:
                        environmentImageFile == null ? _imageFromCamera : null,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child:
                          environmentImageFile != null
                              ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(environmentImageFile!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: _removeImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Tap to capture environment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (environmentImageFile != null && widget.imageUrl != null)
                    CustomButton(
                      text: 'Generate Virtual Photo',
                      onPressed: () {
                        context.pushNamed(
                          AppRoute.virtualPhoto.name,
                          extra: {
                            "plantImageUrl":
                                widget.imageUrl ??
                                'https://m.media-amazon.com/images/I/41zkkbDRApL.__AC_SY300_SX300_QL70_ML2_.jpg',
                            "environmentImageFile": environmentImageFile!,
                          },
                        );
                      },

                      width: SizeConfig.screenWidth! * 0.9,
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
