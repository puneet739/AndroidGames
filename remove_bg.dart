import 'dart:io';
import 'package:image/image.dart';

void main() async {
  final path = 'assets/images/boy_character.png';
  final file = File(path);
  
  if (!fontExists(path)) {
    print("File not found: $path");
    return;
  }

  // Decode
  final image = decodeImage(await file.readAsBytes());
  if (image == null) {
      print("Could not decode image");
      return;
  }

  print("Processing image: ${image.width}x${image.height}");

  // Loop pixels and make white transparent
  // Threshold for "White" (255, 255, 255)
  // Let's be lenient: > 240
  
  for (var pixel in image) {
      // Check if pixel is close to white
      if (pixel.r > 240 && pixel.g > 240 && pixel.b > 240) {
          // Set alpha to 0
          pixel.a = 0;
      }
  }

  // Save
  await file.writeAsBytes(encodePng(image));
  print("Saved transparent image to $path");
}

bool fontExists(String path) => File(path).existsSync();
