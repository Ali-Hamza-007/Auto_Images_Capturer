import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Camera({super.key, required this.cameras});

  @override
  State<Camera> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<Camera> {
  late CameraController _controller;
  bool _isInitialized = false;
  bool isCapturingLoop = false;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Function To initialize Camera
  Future<void> _initializeCamera() async {
    try {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.medium,
      );
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            _isInitialized
                ? Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 180, 201, 212),
                  ),
                  padding: EdgeInsets.all(10),
                  // Use of Stack to put flash and Camera Icon on same CameraPreview Screen
                  child: Stack(
                    children: [
                      // Camera
                      Positioned.fill(child: CameraPreview(_controller)),
                      // Flash Button
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          color: Colors.yellow,
                          onPressed: () {
                            setState(() {
                              isFlashOn = !isFlashOn;
                              if (isFlashOn) {
                                _controller.setFlashMode(FlashMode.torch);
                              } else {
                                _controller.setFlashMode(FlashMode.off);
                              }
                            });
                          },
                          icon: Icon(
                            isFlashOn
                                ? Icons.flash_on_outlined
                                : Icons.flash_off_outlined,
                          ),
                        ),
                      ),
                      // Camera Icon Functinality Code
                      Positioned(
                        bottom: 20,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (isCapturingLoop) {
                                      //  Stop the loop ( Capturing )
                                      setState(() {
                                        isCapturingLoop = false;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("⛔ Stopped capturing"),
                                        ),
                                      );
                                    } else {
                                      //  Start the loop ( Capturing )
                                      setState(() {
                                        isCapturingLoop = true;
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("📸 Started capturing"),
                                        ),
                                      );

                                      while (isCapturingLoop) {
                                        try {
                                          final XFile file =
                                              await _controller.takePicture();

                                          final bool? success =
                                              await GallerySaver.saveImage(
                                                file.path,
                                              );

                                          if (success == true) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  '✅ Image saved to gallery',
                                                ),
                                                duration: Duration(
                                                  milliseconds: 500,
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  '❌ Failed to save image',
                                                ),
                                                duration: Duration(
                                                  milliseconds: 500,
                                                ),
                                              ),
                                            );
                                          }

                                          //  small delay between shots
                                          await Future.delayed(
                                            Duration(seconds: 1),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('⚠️ Error: $e'),
                                            ),
                                          );
                                          break;
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isCapturingLoop
                                            ? Colors.red
                                            : Colors.green,
                                  ),
                                  child: Icon(
                                    isCapturingLoop
                                        ? Icons.stop
                                        : Icons.camera_enhance,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
