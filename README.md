# Cozy Tidy Up 🧸✨

**Cozy Tidy Up** is a relaxing, satisfying puzzle game designed for kids and teens. The goal is simple: bring order to chaos by sorting items into their correct places. It taps into the popular "ASMR Organizing" and "Cozy Gaming" trends.

## 🎮 Game Overview
Players are presented with a messy pile of items and must drag and drop them into the correct containers based on logic (Color, Shape, Type, Pairings). The experience is designed to be stress-free, with positive reinforcement (confetti, sounds) and no time limits.

## ✨ Key Features
*   **10 Unique Levels**: Ranging from simple color sorting to organizing food and electronics.
*   **Simple Controls**: Just drag and drop! Designed for intuitive play by children.
*   **Satisfying Feedback**: Particles and generic feedback on success.
*   **Ad-Supported**: Integrated AdMob Banner ads (gameplay) and Interstitials (between levels) for monetization.
*   **Responsive Design**: Built with Flutter and `flutter_screenutil` to look good on all phone sizes.

## 🕹️ How to Play
1.  **Tap "Play"** on the Main Menu.
2.  **Select a Level** from the grid (Level 1 is the easiest!).
3.  **Read the Instruction** at the top (e.g., "Sort by Color!", "Fruits vs Veggies").
4.  **Drag** an item from the bottom pile.
5.  **Drop** it into the matching zone at the top.
    *   ✅ **Match**: Item disappears from the pile.
    *   ❌ **No Match**: Simple error message, item returns to pile.
6.  **Win**: Clear all items to trigger the Consfetti celebration and unlock the next level!

## 🧩 Level List
1.  **Color Sort**: Sort Pencils by Red, Blue, Green.
2.  **Shape Match**: Fit Circles, Squares, and Stars.
3.  **Food Market**: Separate Fruits from Vegetables.
4.  **Laundry Day**: Match Striped vs Dotted socks.
5.  **Toy Box**: Organize Balls vs Vehicles.
6.  **Weather Sort**: Hot items (Sun/Fire) vs Cold items (Snow/Ice).
7.  **Recycling**: Separate Paper vs Plastic waste.
8.  **Dinner Time**: Sort Forks vs Spoons.
9.  **Study Room**: Separate Electronics from Books.
10. **Ultimate Tidy**: A mix of Stars, Hearts, and Lightning bolts.

## 🛠️ Technical Stack
*   **Framework**: Flutter (Dart)
*   **State Management**: `setState` (Simple & reactive for this scale).
*   **Ads**: `google_mobile_ads` (AdMob).
*   **Responsiveness**: `flutter_screenutil`.
*   **Fonts**: `google_fonts` (Fredoka).

## 🚀 Developer Setup
1.  **Clone the repo**.
2.  Run `flutter pub get`.
3.  **AdMob Setup**:
    *   The app is currently configured with **Test App IDs** in `AndroidManifest.xml`, `Info.plist`, and `lib/utils/ad_helper.dart`.
    *   **Before Publishing**: You MUST replace these IDs with real AdMob Unit IDs.
4.  Run `flutter run`.

## � Build & Deployment (Android)
To generate an Android App Bundle (`.aab`) for the Google Play Store:

1.  **Update Version**: Increment the `version` in `pubspec.yaml` (e.g., `1.0.0+1` → `1.0.0+2`).
2.  **Signing**: Ensure you have a release keystore and it is configured in `android/key.properties`. (See [Flutter Docs](https://docs.flutter.dev/deployment/android#signing-the-app) for help).
3.  **Build Command**:
    Run the following in your terminal:
    ```bash
    flutter build appbundle
    ```
4.  **Locate File**: The output file will be generated at:
    `build/app/outputs/bundle/release/app-release.aab`

## �📦 Future Roadmap (To-Do)
*   [ ] Replace placeholder Icons with custom 2D Sprites.
*   [ ] Add cute sound effects (Pop, Ding, Win).
*   [ ] Add "Shop" to buy background themes with coins (Future IAP integration).

---
*Built with ❤️ for a Cozy Gaming experience.*


Puneet@123
