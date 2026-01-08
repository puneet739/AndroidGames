import 'package:flutter/material.dart';

enum ItemType {
  icon,
  image, // For future use when we have assets
}

class GameItem {
  final String id;
  final String groupId; // Items with same groupId go to the same DropZone
  final ItemType type;
  final IconData? icon;
  final Color? color;
  final String? assetPath;
  final double scale;

  const GameItem({
    required this.id,
    required this.groupId,
    this.type = ItemType.icon,
    this.icon,
    this.color,
    this.assetPath,
    this.scale = 1.0,
  });
}

class DropZoneData {
  final String id;
  final String acceptGroupId; // Accepts items with this groupId
  final Color? color;
  final IconData? icon;
  final String? assetPath;
  final String label;

  const DropZoneData({
    required this.id,
    required this.acceptGroupId,
    this.color,
    this.icon,
    this.assetPath,
    required this.label,
  });
}

class LevelData {
  final int levelNumber;
  final String title;
  final String instruction; // e.g., "Sort by Color!"
  final List<GameItem> items;
  final List<DropZoneData> dropZones;
  final Color backgroundColor;

  const LevelData({
    required this.levelNumber,
    required this.title,
    required this.instruction,
    required this.items,
    required this.dropZones,
    this.backgroundColor = const Color(0xFFF0F4F8),
  });
}
