import 'package:cozy_tidy/game/levels_config.dart';
import 'package:cozy_tidy/screens/sorting_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelSelectorScreen extends StatelessWidget {
  const LevelSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Level", style: GoogleFonts.fredoka(color: Colors.white)),
        backgroundColor: const Color(0xFFFF8FAB),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF0F5),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: GridView.builder(
          itemCount: gameLevels.length, // Should be 10
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
          ),
          itemBuilder: (context, index) {
            final level = gameLevels[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SortingLevelScreen(levelData: level),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(2, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${level.levelNumber}",
                      style: GoogleFonts.fredoka(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF8FAB),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      level.title,
                      style: GoogleFonts.fredoka(fontSize: 16.sp, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
