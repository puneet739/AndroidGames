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
  
  // Character Position
  int _boyAtLevelIndex = 0; // Where the boy currently stands
  int _targetLevelIndex = 0; // Where the boy is running to
  int _startLevelIndex = 0; // Where the boy started running from
  
  // Running Animation
  late AnimationController _runController;
  late AnimationController _positionController; // For horizontal movement
  int _runFrameIndex = 1; // Current frame (1-8)
  bool _isRunning = false;
  bool _runningLeft = false; // Direction: true = going to previous level
  static const int _totalRunFrames = 8;
  
  final double _nodeWidth = 100.w;
  final double _nodeSpacing = 40.w;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Running animation controller - cycles through frames
    _runController = AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 80), // Frame duration
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && _isRunning) {
            // Advance frame and loop
            setState(() {
                _runFrameIndex = (_runFrameIndex % _totalRunFrames) + 1;
            });
            _runController.forward(from: 0.0);
        }
    });
    
    // Position animation controller - for horizontal movement
    _positionController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
    );
    
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    int lvl = await LevelManager.getCurrentLevelIndex();
    setState(() {
      _latestLevel = lvl + 1; 
      _boyAtLevelIndex = lvl;
      _targetLevelIndex = lvl;
    });
    
    // Initial Scroll to position
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(_boyAtLevelIndex, duration: Duration(milliseconds: 100));
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
    _runController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _onLevelTap(int index, LevelData level) {
      if (index >= _latestLevel) return; // Locked
      if (index == _boyAtLevelIndex && !_isRunning) {
          // Already at this level, just enter
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => SortingLevelScreen(levelData: level),
            ),
          ).then((_) => _loadProgress());
          return;
      }

      setState(() {
          _runningLeft = index < _boyAtLevelIndex; // Going backwards?
          _startLevelIndex = _boyAtLevelIndex; // Remember start position
          _targetLevelIndex = index;
          _isRunning = true;
          _runFrameIndex = 1;
      });
      
      // Start running animation
      _runController.forward(from: 0.0);
      
      // Start position animation
      _positionController.forward(from: 0.0);
      
      // Scroll World to bring level to center (Boy runs)
      _scrollToIndex(index);
      
      // Stop running after scroll completes (1 second default)
      Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
              setState(() {
                  _isRunning = false;
                  _boyAtLevelIndex = _targetLevelIndex; // Boy arrived
              });
              // Enter Level
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SortingLevelScreen(levelData: level),
                ),
              ).then((_) => _loadProgress());
          }
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
            
            // 3. RUNNING BOY (Animated position from start to target level)
            if (_isRunning)
                AnimatedBuilder(
                    animation: _positionController,
                    builder: (context, child) {
                        // Calculate horizontal position based on level indices
                        // Start position = center (0.5.sw) when at _startLevelIndex
                        // We need to offset based on how many levels we're moving
                        int levelDiff = _targetLevelIndex - _startLevelIndex;
                        double levelWidth = _nodeWidth + _nodeSpacing;
                        
                        // Since world scrolls and boy stays centered, we just show at center
                        // But boy starts from where it was standing
                        // When world scrolls right (going to higher level), boy should start left and end center
                        // When world scrolls left (going to lower level), boy should start right and end center
                        
                        // Start offset: opposite of scroll direction
                        double startOffset = -levelDiff * levelWidth;
                        double endOffset = 0.0;
                        
                        double currentOffset = startOffset + (endOffset - startOffset) * _positionController.value;
                        
                        return Positioned(
                            bottom: 168.h,
                            left: 0.5.sw - 40.w + currentOffset, // Center minus half boy width plus animated offset
                            child: child!,
                        );
                    },
                    child: SizedBox(
                        width: 80.w,
                        height: 100.h,
                        child: Transform.flip(
                            flipX: _runningLeft,
                            child: Image.asset(
                                'assets/images/boy/run_$_runFrameIndex.png',
                                fit: BoxFit.contain,
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
      bool hasBoy = (index == _boyAtLevelIndex && !_isRunning);
      
      return GestureDetector(
          onTap: () => _onLevelTap(index, level),
          child: SizedBox(
              width: _nodeWidth,
              height: 200.h, // Enough height for boy + hump
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
                      Positioned(
                          bottom: 20.h,
                          child: Container(
                              height: 100.h,
                              width: _nodeWidth,
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
                      ),
                      
                      // BOY CHARACTER (only on current level when idle)
                      if (hasBoy)
                          Positioned(
                              bottom: 130.h, // Above the hump (100h + 20h margin + 10h gap)
                              child: SizedBox(
                                  width: 60.w,
                                  height: 80.h,
                                  child: Image.asset(
                                      'assets/images/boy/run_1.png',
                                      fit: BoxFit.contain,
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
