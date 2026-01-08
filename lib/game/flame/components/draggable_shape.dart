import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart'; // Added
import 'package:flutter/material.dart'; // For Curves
import 'package:cozy_tidy/game/flame/cozy_game.dart';
import 'package:cozy_tidy/game/flame/components/drop_zone_component.dart';

class DraggableShape extends SpriteComponent with DragCallbacks, HasGameReference<CozyTidyGame> {
  final String id;
  final String groupId;
  final Vector2 _originalPosition;
  // ignore: unused_field
  bool _isDragging = false; 

  DraggableShape({
    required this.id,
    required this.groupId,
    required Sprite sprite,
    required Vector2 position,
    required Vector2 size,
  }) : _originalPosition = position.clone(), 
       super(sprite: sprite, position: position, size: size, anchor: Anchor.center);

  @override
  void onDragStart(DragStartEvent event) {
    _isDragging = true;
    priority = 100; // Bring to front
    scale = Vector2.all(1.2); // visuals
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    scale = Vector2.all(1.0);
    priority = 10;
    
    _checkDrop();
    
    super.onDragEnd(event);
  }

  void _checkDrop() {
    // Check collision with any drop zone
    bool matched = false;
    
    for (final component in game.children) {
      if (component is ShapeDropZone) {
        if (component.toRect().overlaps(toRect())) {
           // Collision!
           if (component.acceptGroupId == groupId) {
             matched = true;
             // Success logic
             game.onShapeSorted(this);
           }
        }
      }
    }

    if (!matched) {
      // Snap back
      add(
        MoveEffect.to(
          _originalPosition, 
          EffectController(duration: 0.3, curve: Curves.easeInOut),
        ),
      );
      game.onShapeMissed();
    }
  }
}
