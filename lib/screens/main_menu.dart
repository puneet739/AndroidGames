import 'package:cozy_tidy/game/level_data.dart';
import 'package:cozy_tidy/game/level_manager.dart';
import 'package:cozy_tidy/screens/sorting_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart'; 
import 'package:cozy_tidy/screens/level_selector.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  Future<void> _startGame(BuildContext context) async {
    // 1. Get saved level
    int levelIndex = await LevelManager.getCurrentLevelIndex();
    
    // 2. Get data for that level
    LevelData data = LevelManager.getLevelData(levelIndex);

    // 3. Launch Game
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SortingLevelScreen(levelData: data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Cozy Tidy',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4C83), // Cozy purple
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Satisfying Organizing',
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF9CA6B8),
              ),
            ),
            SizedBox(height: 60.h),

            // Big Play Button
            _buildMenuButton(
              context: context,
              label: 'PLAY',
              color: const Color(0xFFFF8FAB), // Soft pink
              onTap: () => _startGame(context),
            ),
            SizedBox(height: 20.h),

            // Levels Button
            _buildMenuButton(
              context: context,
              label: 'LEVELS',
              color: const Color(0xFFFFD54F), // Amber
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LevelSelectorScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            
            // Settings / Shop implementation placeholders
            _buildMenuButton(
              context: context,
              label: 'SHOP',
              color: const Color(0xFF8FD3FF), // Soft blue
              iconPath: 'assets/images/skip_button.png',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? iconPath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              Image.asset(
                iconPath,
                width: 24.w,
                height: 24.w, // square
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
