import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:cozy_tidy/game/level_data.dart';
import 'package:cozy_tidy/game/flame/components/draggable_shape.dart';
import 'package:cozy_tidy/game/flame/components/drop_zone_component.dart';

class CozyTidyGame extends FlameGame {
  final LevelData levelData;
  final VoidCallback onWin;
  final VoidCallback onSuccess; // Play pop sound on correct drop
  final VoidCallback onExampleFailure; // To play sound via Flutter wrapper if needed
  
  late SpriteSheet shapeSpriteSheet;
  
  CozyTidyGame({required this.levelData, required this.onWin, required this.onSuccess, required this.onExampleFailure});

  @override
  Color backgroundColor() => const Color(0xFFFFF3E0); // Level 2 BG Color hardcoded or from data

  @override
  Future<void> onLoad() async {
    // Load the sprite sheet image (1024x1024 based on earlier script)
    final image = await images.load('shapes_spritesheet.png');
    
    // EXACT COORDINATES from user (converted from CSS background-position)
    // CSS: background-position: -X -Y means srcPosition: (X, Y)
    
    // Helper to create Sprite from pixel region
    Sprite getSprite(double x, double y, double w, double h) {
        return Sprite(image, srcPosition: Vector2(x, y), srcSize: Vector2(w, h));
    }
    
    // --- DRAGGABLE ITEMS ---
    // Sun: -23px -23px, 165x164
    final sunSprite = getSprite(23, 23, 165, 164);
    // Wheel: -205px -33px, 128x142
    final wheelSprite = getSprite(205, 33, 128, 142);
    // TV: -333px -22px, 157x159
    final tvSprite = getSprite(333, 22, 157, 159);
    // Mobile: -127px -190px, 77x104
    final mobileSprite = getSprite(127, 190, 77, 104);
    
    // --- DROP ZONE TARGETS ---
    // Circle: -19px -310px, 177x175
    final circleTargetSprite = getSprite(19, 310, 177, 175);
    // Rectangle: -209px -304px, 270x180
    final rectTargetSprite = getSprite(209, 304, 270, 180);

    double zoneY = size.y * 0.3;
    
    add(ShapeDropZone(
      id: 'dz_circle',
      acceptGroupId: 'circle',
      sprite: circleTargetSprite,
      position: Vector2(size.x * 0.3, zoneY),
      size: Vector2(120, 100),
    ));

    add(ShapeDropZone(
      id: 'dz_rect',
      acceptGroupId: 'rectangle',
      sprite: rectTargetSprite,
      position: Vector2(size.x * 0.7, zoneY),
      size: Vector2(140, 100),
    ));
    
    // Spawn Items
    _spawnItem('c1', 'circle', sunSprite, Vector2(size.x * 0.15, size.y * 0.7)); // Sun
    _spawnItem('c2', 'circle', wheelSprite, Vector2(size.x * 0.38, size.y * 0.7)); // Wheel
    _spawnItem('r1', 'rectangle', tvSprite, Vector2(size.x * 0.62, size.y * 0.7)); // TV
    _spawnItem('r2', 'rectangle', mobileSprite, Vector2(size.x * 0.85, size.y * 0.7)); // Mobile
  }
  
  void _spawnItem(String id, String group, Sprite sprite, Vector2 pos) {
      add(DraggableShape(
          id: id,
          groupId: group,
          sprite: sprite,
          position: pos,
          size: Vector2(80, 80),
      ));
  }
  
  void onShapeSorted(DraggableShape shape) {
      // Valid drop - play success sound
      onSuccess();
      shape.removeFromParent();
      
      // Check win condition
      // Count remaining draggable shapes
      int remaining = children.whereType<DraggableShape>().length - 1; // -1 because this one is still in list during callback
      if (remaining <= 0) {
          onWin();
      }
  }
  
  void onShapeMissed() {
      onExampleFailure();
  }
}
