import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShapeDropZone extends SpriteComponent {
  final String id;
  final String acceptGroupId;

  ShapeDropZone({
    required this.id, 
    required this.acceptGroupId,
    required Sprite sprite,
    required Vector2 position,
    required Vector2 size,
  }) : super(sprite: sprite, position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Optional: Draw a debug debug border
    // canvas.drawRect(size.toRect(), Paint()..style = PaintingStyle.stroke ..color = Colors.green ..strokeWidth = 2);
  }
}
