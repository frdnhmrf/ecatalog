import 'package:camera/camera.dart';
import 'package:ecatalog/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final Function(XFile) takePicture;
  final List<CameraDescription>? cameras;
  const CameraPage({required this.takePicture, this.cameras, super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;

  XFile? capturedImage;

  Future takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      controller.setFlashMode(FlashMode.torch);
      XFile image = await controller.takePicture();
      controller.setFlashMode(FlashMode.off);

      widget.takePicture(image);

      Navigator.pop(context);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    } catch (e) {
      // Tangani kesalahan yang mungkin terjadi saat mengambil foto
    }
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object error) {
      if (error is CameraException) {
        switch (error.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
        debugPrint(
            'Error occured while initializing camera: ${error.description}');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CameraPreview(controller),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.appColors.primary,
                  ),
                  onPressed: () {
                    takePicture();
                  },
                  child: const Text('Ambil Poto'),
                ),
              )
            ],
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}
