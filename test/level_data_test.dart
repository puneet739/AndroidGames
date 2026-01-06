import 'package:cozy_tidy/game/level_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LevelData Tests', () {
    test('GameItem initialization', () {
      const item = GameItem(
        id: 'item_1',
        groupId: 'group_A',
        icon: Icons.abc,
      );

      expect(item.id, 'item_1');
      expect(item.groupId, 'group_A');
      expect(item.type, ItemType.icon);
    });

    test('DropZoneData initialization', () {
      const zone = DropZoneData(
        id: 'zone_1',
        acceptGroupId: 'group_A',
        label: 'Zone A',
      );

      expect(zone.id, 'zone_1');
      expect(zone.acceptGroupId, 'group_A');
      expect(zone.label, 'Zone A');
    });

    test('LevelData structure', () {
      final level = LevelData(
        levelNumber: 1,
        title: 'Test Level',
        instruction: 'Sort things',
        items: [
           const GameItem(id: 'i1', groupId: 'g1'),
        ],
        dropZones: [
           const DropZoneData(id: 'z1', acceptGroupId: 'g1', label: 'Z1'),
        ],
      );

      expect(level.levelNumber, 1);
      expect(level.items.length, 1);
      expect(level.dropZones.length, 1);
    });
  });
}
