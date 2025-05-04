import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'package:gharas_saudi_app/features/plants/services/image_generate_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class VirtualPhotoView extends StatefulWidget {
  final String plantImageUrl;
  final XFile environmentImageFile;

  const VirtualPhotoView({
    super.key,
    required this.plantImageUrl,
    required this.environmentImageFile,
  });

  @override
  State<VirtualPhotoView> createState() => _VirtualPhotoViewState();
}

class _VirtualPhotoViewState extends State<VirtualPhotoView> {
  bool _isSaving = false;
  bool _isSharing = false;
  bool isGeneratingVirtualPhoto = false;
  String? virtualUrl;

  @override
  void initState() {
    super.initState();
    _generateVirtualPhoto();
  }

  Future<void> _generateVirtualPhoto() async {
    setState(() => isGeneratingVirtualPhoto = true);

    try {
      final imageGenerateResult =
          await ImageGenerateService.generatePlantSimulation(
            plantImageUrl: widget.plantImageUrl,
            environmentImage: widget.environmentImageFile,
          );

      if (!mounted) return;
      if (imageGenerateResult.success) {
        setState(() {
          virtualUrl = imageGenerateResult.imageUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(imageGenerateResult.message),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isGeneratingVirtualPhoto = false);
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      if (await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    }
    return true; // iOS doesn't require this
  }

  Future<void> _saveImage() async {
    if (virtualUrl == null) return;

    setState(() => _isSaving = true);
    try {
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      final bytes = base64Decode(virtualUrl!.split(',').last);
      final dir = await getExternalStorageDirectory();
      final file = File(
        '${dir!.path}/virtual_plant_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved to: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _shareImage() async {
    if (virtualUrl == null) return;

    setState(() => _isSharing = true);
    try {
      final bytes = base64Decode(virtualUrl!.split(',').last);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/virtual_plant_share.png');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Check out this plant simulation I created!',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(title: 'Virtual Photo', subtitle: 'Powered by AI'),
          Expanded(
            child:
                !isGeneratingVirtualPhoto
                    ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Container(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: _buildVirtualImage(virtualUrl),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Action buttons
                          Wrap(
                            spacing: 20,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildActionButton(
                                icon: Icons.save_alt,
                                label: 'Save',
                                isLoading: _isSaving,
                                onPressed: _saveImage,
                              ),
                              _buildActionButton(
                                icon: Icons.share,
                                label: 'Share',
                                isLoading: _isSharing,
                                onPressed: _shareImage,
                              ),
                              _buildActionButton(
                                icon: Icons.refresh,
                                label: 'Refresh',
                                isLoading: isGeneratingVirtualPhoto,
                                onPressed: _generateVirtualPhoto,
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20),
                        ],
                      ),
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: SizeConfig.screenWidth! * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[Color(0xFF6A8D73), Color(0xFF9CE0B2)],
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No image available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        return Center(
          child: Text(
            'Error loading image',
            style: TextStyle(fontSize: 16, color: Colors.red[400]),
          ),
        );
      }
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
                const SizedBox(height: 10),
                const Text(
                  'Failed to load image',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
