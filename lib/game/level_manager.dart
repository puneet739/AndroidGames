import 'package:shared_preferences/shared_preferences.dart';
import 'package:cozy_tidy/game/levels_config.dart';
import 'package:cozy_tidy/game/level_data.dart';

class LevelManager {
  static const String _levelKey = 'current_level_index';

  // Get current level index from disk
  static Future<int> getCurrentLevelIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_levelKey) ?? 0;
  }

  // Save level progress
  static Future<void> unlockNextLevel() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_levelKey) ?? 0;
    await prefs.setInt(_levelKey, current + 1);
  }

  // Get Level Data (Generative / Cycling)
  // We use modulo arithmetic to cycle through our 10 configs endlessly.
  // Level 11 -> Config 1 (but we can change title to Level 11)
  static LevelData getLevelData(int index) {
    // Basic cycle
    final configIndex = index % gameLevels.length;
    final baseConfig = gameLevels[configIndex];

    // We return a modification of the base config with the correct level number display
    return LevelData(
      levelNumber: index + 1, // Display "Level 11" even if it's config 1
      title: baseConfig.title,
      instruction: baseConfig.instruction,
      items: baseConfig.items,
      dropZones: baseConfig.dropZones,
      backgroundColor: baseConfig.backgroundColor,
    );
  }
}
