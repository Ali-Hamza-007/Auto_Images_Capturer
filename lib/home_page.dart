import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Camera.dart';

class HomePage extends StatelessWidget {
  final cameras;
  const HomePage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        leading: Icon(Icons.image_sharp, color: Colors.white),

        backgroundColor: Colors.blue,
        title: const Text('Auto Images Capture'),
        titleTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(color: Colors.white),
        ),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome To !!!',
              style: GoogleFonts.nunito(
                color: Colors.blueGrey,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Auto Images Capture',
                style: GoogleFonts.nunito(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, top: 8),
              child: Text(
                'Click the Camera Button Below.',
                style: GoogleFonts.nunito(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      // Footer ( Bottom Bar )
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Made with ❤️ by HAMZA'),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final cameras = await availableCameras();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Camera(cameras: cameras)),
          );
        },
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}
