import 'dart:io';
import 'package:image/image.dart';

void main() async {
  final path = 'assets/images/shapes_spritesheet.png';
  final file = File(path);
  
  if (!file.existsSync()) {
    print("File not found: $path");
    return;
  }

  // Decode
  final image = decodeImage(await file.readAsBytes());
  if (image == null) {
      print("Could not decode image");
      return;
  }

  print("Processing Sprite Sheet: ${image.width}x${image.height}");
  
  // User Description:
  // Row 1: Sun, Wheel, TV
  // Row 2: Mobile, Mobile (Maybe duplicates?)
  // Row 3: Circle, Rectangle
  
  // Implementation:
  // We will assume a 3x3 Grid.
  int cols = 3;
  int rows = 3;
  
  int cellWidth = image.width ~/ cols;
  int cellHeight = image.height ~/ rows;
  
  // Helper to slice and save
  Future<void> saveSlice(int col, int row, String name) async {
      int x = col * cellWidth;
      int y = row * cellHeight;
      
      // Crop
      final slice = copyCrop(image, x: x, y: y, width: cellWidth, height: cellHeight);
      
      // Remove White Background (Generic)
      for (var pixel in slice) {
          if (pixel.r > 240 && pixel.g > 240 && pixel.b > 240) {
              pixel.a = 0;
          }
      }
      
      await File('assets/images/$name.png').writeAsBytes(encodePng(slice));
      print("Saved assets/images/$name.png");
  }
  
  // Row 0
  await saveSlice(0, 0, 'shape_sun');
  await saveSlice(1, 0, 'shape_wheel');
  await saveSlice(2, 0, 'shape_tv');
  
  // Row 1
  await saveSlice(0, 1, 'shape_mobile');
  // Ignore second mobile for now unless it's different. User said "mobile, mobile". 
  
  // Row 2
  await saveSlice(0, 2, 'target_circle');
  await saveSlice(1, 2, 'target_rectangle');
}
