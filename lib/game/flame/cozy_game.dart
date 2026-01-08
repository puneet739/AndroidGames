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
  final VoidCallback onExampleFailure; // To play sound via Flutter wrapper if needed
  
  late SpriteSheet shapeSpriteSheet;
  
  CozyTidyGame({required this.levelData, required this.onWin, required this.onExampleFailure});

  @override
  Color backgroundColor() => const Color(0xFFFFF3E0); // Level 2 BG Color hardcoded or from data

  @override
  Future<void> onLoad() async {
    // Load the sprite sheet
    // Assumes 3x3 grid as per user description
    // Row 1: Sun, Wheel, TV
    // Row 2: Mobile, Mobile
    // Row 3: Circle, Rectangle
    final image = await images.load('shapes_spritesheet.png');
    
    // We assume the sheet is square-ish or just check image size
    // For 3x3, texture width/3, height/3
    shapeSpriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(image.width / 3, image.height / 3),
    );

    // Setup Drop Zones
    // Circle Target -> Row 3, Col 1 (Index 2, 0)
    // Rect Target -> Row 3, Col 2 (Index 2, 1)
    
    final circleTargetSprite = shapeSpriteSheet.getSprite(2, 0);
    final rectTargetSprite = shapeSpriteSheet.getSprite(2, 1);
    
    double zoneY = size.y * 0.3;
    
    add(ShapeDropZone(
      id: 'dz_circle',
      acceptGroupId: 'circle',
      sprite: circleTargetSprite,
      position: Vector2(size.x * 0.3, zoneY),
      size: Vector2(100, 100),
    ));

    add(ShapeDropZone(
      id: 'dz_rect',
      acceptGroupId: 'rectangle',
      sprite: rectTargetSprite,
      position: Vector2(size.x * 0.7, zoneY),
      size: Vector2(100, 100),
    ));
    
    // Setup Items
    // Hardcoded mapping for Level 2 items to grid positions
    // Sun: 0,0
    // Wheel: 0,1
    // TV: 0,2
    // Mobile: 1,0 (or 1,1)
    
    _spawnItem('c1', 'circle', 0, 0, Vector2(size.x * 0.2, size.y * 0.7)); // Sun
    _spawnItem('c2', 'circle', 0, 1, Vector2(size.x * 0.4, size.y * 0.7)); // Wheel
    _spawnItem('r1', 'rectangle', 0, 2, Vector2(size.x * 0.6, size.y * 0.7)); // TV
    _spawnItem('r2', 'rectangle', 1, 0, Vector2(size.x * 0.8, size.y * 0.7)); // Mobile
  }
  
  void _spawnItem(String id, String group, int row, int col, Vector2 pos) {
      add(DraggableShape(
          id: id,
          groupId: group,
          sprite: shapeSpriteSheet.getSprite(row, col),
          position: pos,
          size: Vector2(80, 80),
      ));
  }
  
  void onShapeSorted(DraggableShape shape) {
      // Valid drop
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
