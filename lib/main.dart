import 'package:cozy_tidy/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait for now, or landscape depending on game design.
  // "Tidy Up" games often work well in portrait for one-handed play, 
  // but "sorting" might need width. Let's go with Portrait for simplicity first.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  MobileAds.instance.initialize();
  runApp(const CozyTidyApp());
}

class CozyTidyApp extends StatelessWidget {
  const CozyTidyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit handles responsiveness. 
    // Design size is set to a standard mobile dimension (e.g., iPhone 11 approx).
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Cozy Tidy Up',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.fredokaTextTheme(), // Friendly, rounded font
            scaffoldBackgroundColor: const Color(0xFFF0F4F8), // Soft pastel background
            useMaterial3: true,
          ),
          home: const MainMenuScreen(),
        );
      },
    );
  }
}
