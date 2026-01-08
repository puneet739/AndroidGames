import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cozy_tidy/game/level_data.dart';
import 'package:cozy_tidy/game/level_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cozy_tidy/utils/ad_helper.dart';
import 'package:flame/game.dart'; // GameWidget
import 'package:cozy_tidy/game/flame/cozy_game.dart'; // CozyTidyGame

class SortingLevelScreen extends StatefulWidget {
  final LevelData levelData;

  const SortingLevelScreen({super.key, required this.levelData});

  @override
  State<SortingLevelScreen> createState() => _SortingLevelScreenState();
}

class _SortingLevelScreenState extends State<SortingLevelScreen> {
  // State: Which items are still on the "table" (not sorted yet)
  late List<GameItem> unsortedItems;
  
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ADS
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    unsortedItems = List.from(widget.levelData.items);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Load Banner
    _bannerAd = AdHelper.loadBannerAd(
      onLoaded: () {
        setState(() {
          _isBannerLoaded = true;
        });
      },
    );

    // Load Interstitial
    AdHelper.loadInterstitialAd(
      onLoaded: (ad) {
        _interstitialAd = ad;
      },
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  // ignore: unused_element
  Future<void> _playSound(String name) async {
    try {
      await _audioPlayer.stop(); // Stop previous sound if any
      await _audioPlayer.play(AssetSource('audio/$name.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void _onItemDropped(GameItem item, DropZoneData zone) {
    if (item.groupId == zone.acceptGroupId) {
      // Correct!
      _playSound('pop'); 
      setState(() {
        unsortedItems.remove(item);
      });
      
      if (unsortedItems.isEmpty) {
        _handleWin();
      }
    } else {
      _playSound('failure'); // Play failure sound
    }
  }

  void _handleWin() {
    _playSound('win');
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Level Complete!', style: TextStyle(), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 60),
            SizedBox(height: 10.h),
            Text('Amazing Job!', style: TextStyle(fontSize: 18.sp)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // 1. Show Ad
              if (_interstitialAd != null) {
                _interstitialAd!.show();
                _interstitialAd = null; 
              }
              
              Navigator.of(context).pop(); // Close dialog

              // 2. Unlock Next Level Logic
              await LevelManager.unlockNextLevel();
              int nextIndex = await LevelManager.getCurrentLevelIndex();
              LevelData nextLevel = LevelManager.getLevelData(nextIndex);

              // 3. Replace current screen with Next Level (so back button goes to menu)
              if (context.mounted) {
                 Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SortingLevelScreen(levelData: nextLevel),
                  ),
                );
              }
            },
            child: Text('Next Level', style: TextStyle(fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // HYBRID INTEGRATION: Use Flame for Level 2
    if (widget.levelData.levelNumber == 2) {
        return Scaffold(
            body: Stack(
                children: [
                    // FLAME GAME
                    GameWidget(
                        game: CozyTidyGame(
                            levelData: widget.levelData,
                            onWin: () {
                                _handleWin(); // Re-use existing Flutter win dialog
                            },
                            onExampleFailure: () {
                                _playSound('failure');
                            },
                        ),
                    ),
                    
                    // OVERLAY UI (Back Button)
                    Positioned(
                        top: 40.h,
                        left: 20.w,
                        child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.brown, size: 30),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ),
                    // INSTRUCTION TEXT
                    Positioned(
                        top: 60.h,
                        left: 0, 
                        right: 0,
                        child: Center(
                            child: Text(
                                widget.levelData.instruction,
                                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.brown),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    return Scaffold(
      backgroundColor: widget.levelData.backgroundColor,
      appBar: AppBar(
        title: Text(widget.levelData.title, style: TextStyle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                    setState(() {
                        unsortedItems = List.from(widget.levelData.items);
                    });
                },
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              // Instruction
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  widget.levelData.instruction,
                  style: TextStyle(fontSize: 22.sp, color: Colors.black54),
                ),
              ),

              // 1. DROP ZONES
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.levelData.dropZones.map((zone) {
                    return DragTarget<GameItem>(
                      onWillAcceptWithDetails: (details) => true, // Accept any visual drop to check logic inside
                      onAcceptWithDetails: (details) => _onItemDropped(details.data, zone),
                      builder: (context, candidateData, rejectedData) {
                        bool isHovering = candidateData.isNotEmpty;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 100.w,
                          height: 140.h,
                          decoration: BoxDecoration(
                            color: zone.color ?? Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isHovering ? Colors.green : Colors.black12,
                              width: isHovering ? 3 : 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                if (zone.assetPath != null)
                                  Image.asset(zone.assetPath!, width: 50.sp, height: 50.sp, opacity: const AlwaysStoppedAnimation(0.5)) // Faded target
                                else if (zone.icon != null)
                                    Icon(zone.icon, size: 40.sp, color: Colors.black26),

                                if (zone.label.isNotEmpty)
                                    Text(zone.label, style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              // 2. DRAGGABLE ITEMS
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Stack(
                    children: [
                        Center(
                            child: Wrap(
                            spacing: 20.w,
                            runSpacing: 20.h,
                            alignment: WrapAlignment.center,
                            children: unsortedItems.map((item) {
                                return Draggable<GameItem>(
                                data: item,
                                feedback: _buildItemVisual(item, size: 80.sp, isFeedback: true),
                                childWhenDragging: Opacity(
                                    opacity: 0.3, 
                                    child: _buildItemVisual(item, size: 70.sp),
                                ),
                                child: _buildItemVisual(item, size: 70.sp),
                                );
                            }).toList(),
                            ),
                        ),
                        // BANNER AD at Bottom of this section
                        if (_isBannerLoaded && _bannerAd != null)
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd!),
                                ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Confetti Overlay
            Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemVisual(GameItem item, {required double size, bool isFeedback = false}) {
    Widget child = item.assetPath != null
        ? Image.asset(item.assetPath!, width: size, height: size)
        : Icon(item.icon, size: size, color: item.color);

    // If feedback (being dragged), make it a bit bigger or shadow
    if (isFeedback) {
        return Material( // Needs Material to draw shadow/elevation
            color: Colors.transparent,
            child: Transform.scale(scale: 1.2, child: child),
        );
    }
    return child;
  }
}
