import 'package:cozy_tidy/game/levels_config.dart';
import 'package:cozy_tidy/game/level_data.dart';
import 'package:cozy_tidy/game/level_manager.dart';
import 'package:cozy_tidy/screens/sorting_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelSelectorScreen extends StatefulWidget {
  const LevelSelectorScreen({super.key});

  @override
  State<LevelSelectorScreen> createState() => _LevelSelectorScreenState();
}

class _LevelSelectorScreenState extends State<LevelSelectorScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  int _latestLevel = 1;
  
  // Character Animation
  int _selectedLevelIndex = 0; // Where the boy is currently standing (visual logic)
  
  // Animation for "Running"
  // We need to track the visual horizontal position.
  // We can't easily track absolute pixels of list items.
  // Simplification: We will center the selected item in the viewport and keep the boy centered (or slightly offset).
  // BUT the user wants the boy to "Run to next level". This implies the list stays still or moves differently.
  // APPROACH B: The boy stays near center, the WORLD moves (scrolls).
  // When tapping a new level, we scroll the list so that the new level is under the boy.
  // And the boy plays a "Running" animation while the list scrolls.
  
  // Current State: Boy is part of the item.
  // New State: Boy is FIXED on screen (or animates slightly) while list scrolls.
  
  late AnimationController _jumpController;
  late Animation<double> _jumpHeightAnimation;
  
  final double _nodeWidth = 100.w;
  final double _nodeSpacing = 40.w;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    _jumpController = AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 500),
    );

    _jumpHeightAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut));
    
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    int lvl = await LevelManager.getCurrentLevelIndex();
    setState(() {
      _latestLevel = lvl + 1; 
      _selectedLevelIndex = lvl;
    });
    
    // Initial Scroll to position
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(_selectedLevelIndex, duration: Duration(milliseconds: 100));
    });
  }
  
  void _scrollToIndex(int index, {Duration duration = const Duration(seconds: 1)}) {
      if (!_scrollController.hasClients) return;
      // Calculate target to center the item:
      // Item Center = (index * (width + space)) + (width/2) + Padding
      // Screen Center = 0.5.sw
      // Offset = ItemCenter - ScreenCenter
      
      double itemPos = (index + 1) * (_nodeWidth + _nodeSpacing); // +1 because index 0 is head
      // Wait, Index logic: Head is index 0. Level 1 is index 1.
      // So LevelIndex 0 (Level 1) is actually ItemIndex 1.
      
      double headWidth = 120.w;
      double offsetForHead = headWidth + _nodeSpacing; // Head takes up space
      
      double targetItemStart = offsetForHead + (index * (_nodeWidth + _nodeSpacing));
      double targetCenter = targetItemStart + (_nodeWidth / 2);
      
      double scrollOffset = targetCenter - 0.5.sw;
      if (scrollOffset < 0) scrollOffset = 0;
      
      _scrollController.animateTo(scrollOffset, duration: duration, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  void _onLevelTap(int index, LevelData level) {
      if (index >= _latestLevel) return; // Locked

      setState(() {
          _selectedLevelIndex = index;
      });
      
      // 1. Scroll World to bring level to center (Boy runs)
      _scrollToIndex(index);
      
      // 2. Play Jump/Run animation
      _jumpController.forward(from: 0.0).then((_) {
           // 3. Enter Level
           Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => SortingLevelScreen(levelData: level),
            ),
          ).then((_) => _loadProgress());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
            // 1. BACKGROUND
            Positioned.fill(
                child: Image.asset(
                    'assets/images/jungle_background.png',
                    fit: BoxFit.cover,
                ),
            ),

            // 2. CATERPILLAR LIST
            Positioned(
                bottom: 50.h,
                height: 300.h,
                left: 0,
                right: 0,
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 50.w), // initial padding
                    itemCount: gameLevels.length + 1,
                    itemBuilder: (context, index) {
                        if (index == 0) return _buildCaterpillarHead();
                        int levelIndex = index - 1;
                        return _buildCaterpillarSegment(gameLevels[levelIndex], levelIndex);
                    },
                ),
            ),
            
            // 3. BOY CHARACTER (Independent Overlay)
            // We fix the boy at the visual "Target" location in the screen center (mostly).
            // Since we scroll the world to center the item, the boy effectively stays near center.
            // But to give "running" feel, we can just animate him bobbing.
            Positioned(
                bottom: 155.h, // Adjusted to stand ON TOP of the hump (Hump is 100h + 20 margin + 50 bottom) -> approx 170
                child: IgnorePointer( // Let clicks pass through to list
                    child: AnimatedBuilder(
                        animation: _jumpController,
                        builder: (context, child) {
                            // Simple Jump/Bob
                            double jumpOffset = _jumpHeightAnimation.value * 30.h;
                            // Maybe sine wave for running?
                            return Transform.translate(
                                offset: Offset(0, -jumpOffset), 
                                child: child,
                            );
                        },
                        child: Container(
                            width: 80.w, // Slightly bigger
                            height: 100.h,
                            child: Image.asset('assets/images/boy_character.png'),
                        ),
                    ),
                ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaterpillarHead() {
     return Container(
         margin: const EdgeInsets.only(right: 0), 
         width: 120.w,
         alignment: Alignment.bottomCenter,
         child: Container( 
             height: 120.w,
             decoration: BoxDecoration(
                 color: const Color(0xFF66BB6A), 
                 shape: BoxShape.circle,
                 border: Border.all(color: Colors.white, width: 4),
                 boxShadow: const [
                     BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(5, 5)),
                 ],
             ),
             child: const Center(
                 child: Icon(Icons.face, color: Colors.white, size: 60), 
             ),
         ),
     );
  }

  Widget _buildCaterpillarSegment(LevelData level, int index) {
      bool isLocked = index >= _latestLevel;
      // Note: We removed "isSelected" logic from here as the boy is outside.
      
      return GestureDetector(
          onTap: () => _onLevelTap(index, level),
          child: Container(
              width: _nodeWidth,
              margin: EdgeInsets.symmetric(horizontal: _nodeSpacing / 2),
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                      // LEGS
                      Positioned(
                          bottom: 0,
                          child: Row(
                              children: [
                                  _buildLeg(), SizedBox(width: 20.w), _buildLeg(),
                              ],
                          ),
                      ),
                      
                      // HUMP BODY
                      Container(
                          height: 100.h,
                          width: _nodeWidth,
                          margin: EdgeInsets.only(bottom: 20.h), 
                          decoration: BoxDecoration(
                              color: isLocked ? Colors.grey : const Color(0xFF81C784),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(50.r), bottom: Radius.circular(20.r)),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                 BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)), 
                              ],
                          ),
                          child: Center(
                              child: isLocked 
                                ? const Icon(Icons.lock, color: Colors.white54)
                                : Text(
                                    "${level.levelNumber}",
                                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                      ),
                  ],
              ),
          ),
      );
  }

  Widget _buildLeg() {
      return Container(
          width: 10.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(5),
          ),
      );
  }
}
