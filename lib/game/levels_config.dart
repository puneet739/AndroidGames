
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // We might need this for more icons, but let's stick to Material for now or add font_awesome if needed.
import 'level_data.dart';

// Helper to generate unique IDs
// String _uid(String prefix, int index) => '$prefix-$index';

final List<LevelData> gameLevels = [
  // LEVEL 1: Colors (Pencils)
  LevelData(
    levelNumber: 1,
    title: 'Color Sort',
    instruction: 'Put pencils in matching cups!',
    backgroundColor: const Color(0xFFE3F2FD),
    items: [
      GameItem(id: 'r1', groupId: 'red', icon: Icons.edit, color: Colors.red),
      GameItem(id: 'r2', groupId: 'red', icon: Icons.edit, color: Colors.red),
      GameItem(id: 'b1', groupId: 'blue', icon: Icons.edit, color: Colors.blue),
      GameItem(id: 'b2', groupId: 'blue', icon: Icons.edit, color: Colors.blue),
      GameItem(id: 'g1', groupId: 'green', icon: Icons.edit, color: Colors.green),
    ],
    dropZones: [
      DropZoneData(id: 'dz_red', acceptGroupId: 'red', color: Colors.red.shade100, label: 'Red'),
      DropZoneData(id: 'dz_blue', acceptGroupId: 'blue', color: Colors.blue.shade100, label: 'Blue'),
      DropZoneData(id: 'dz_green', acceptGroupId: 'green', color: Colors.green.shade100, label: 'Green'),
    ],
  ),

  // LEVEL 2: Shapes (Circle vs Rectangle)
  LevelData(
    levelNumber: 2,
    title: 'Shape Match',
    instruction: 'Sort by Shape!',
    backgroundColor: const Color(0xFFFFF3E0),
    items: [
      // CIRCLES
      GameItem(
        id: 'c1', 
        groupId: 'circle', 
        icon: Icons.wb_sunny, // Fallback
        assetPath: 'assets/images/shape_sun.png',
        color: Colors.transparent
      ),
      GameItem(
        id: 'c2', 
        groupId: 'circle', 
        icon: Icons.local_shipping,
        assetPath: 'assets/images/shape_wheel.png',
        color: Colors.transparent
      ),
      // RECTANGLES
      GameItem(
        id: 'r1', 
        groupId: 'rectangle', 
        icon: Icons.tv,
        assetPath: 'assets/images/shape_tv.png',
        color: Colors.transparent
      ),
      GameItem(
        id: 'r2', 
        groupId: 'rectangle', 
        icon: Icons.phone_android,
        assetPath: 'assets/images/shape_mobile.png',
        color: Colors.transparent
      ),
    ],
    dropZones: [
      DropZoneData(
        id: 'dz_circle', 
        acceptGroupId: 'circle', 
        label: 'Round',
        assetPath: 'assets/images/target_circle.png'
      ),
      DropZoneData(
        id: 'dz_rect', 
        acceptGroupId: 'rectangle', 
        label: 'Boxy',
        assetPath: 'assets/images/target_rectangle.png'
      ),
    ],
  ),

  // LEVEL 3: Food Types (Fruits vs Veggies)
  LevelData(
    levelNumber: 3,
    title: 'Food Market',
    instruction: 'Separate Fruits and Veggies!',
    backgroundColor: const Color(0xFFE8F5E9),
    items: [
      GameItem(id: 'f1', groupId: 'fruit', icon: Icons.apple, color: Colors.red), // Apple
      GameItem(id: 'v1', groupId: 'veg', icon: Icons.grass, color: Colors.green), // Broccoli-ish
      GameItem(id: 'f2', groupId: 'fruit', icon: Icons.eco, color: Colors.orange), // Orange-ish
      GameItem(id: 'v2', groupId: 'veg', icon: Icons.local_florist, color: Colors.green), // Lettuce
    ],
    dropZones: [
      DropZoneData(id: 'dz_fruit', acceptGroupId: 'fruit', color: Colors.red.shade50, label: 'Fruits'),
      DropZoneData(id: 'dz_veg', acceptGroupId: 'veg', color: Colors.green.shade50, label: 'Veggies'),
    ],
  ),

  // LEVEL 4: Laundry (Socks)
  LevelData(
    levelNumber: 4,
    title: 'Laundry Day',
    instruction: 'Pair the socks!',
    backgroundColor: const Color(0xFFF3E5F5),
    items: [
      GameItem(id: 's1', groupId: 'striped', icon: Icons.theater_comedy, color: Colors.blue), // Placeholder
      GameItem(id: 's2', groupId: 'dotted', icon: Icons.theater_comedy, color: Colors.pink),
      GameItem(id: 's3', groupId: 'striped', icon: Icons.theater_comedy, color: Colors.blue),
      GameItem(id: 's4', groupId: 'dotted', icon: Icons.theater_comedy, color: Colors.pink),
    ],
    dropZones: [
      DropZoneData(id: 'dz_striped', acceptGroupId: 'striped', color: Colors.blue.shade50, label: 'Striped'),
      DropZoneData(id: 'dz_dotted', acceptGroupId: 'dotted', color: Colors.pink.shade50, label: 'Dotted'),
    ],
  ),

  // LEVEL 5: Toys (Ball vs Car) - simplified for now
  LevelData(
    levelNumber: 5,
    title: 'Toy Box',
    instruction: 'Organize the toys!',
    backgroundColor: const Color(0xFFFFFDE7),
    items: [
      GameItem(id: 't1', groupId: 'ball', icon: Icons.sports_soccer, color: Colors.black87),
      GameItem(id: 't2', groupId: 'car', icon: Icons.directions_car, color: Colors.red),
      GameItem(id: 't3', groupId: 'ball', icon: Icons.sports_basketball, color: Colors.orange),
      GameItem(id: 't4', groupId: 'car', icon: Icons.local_shipping, color: Colors.blue),
    ],
    dropZones: [
      DropZoneData(id: 'dz_ball', acceptGroupId: 'ball', label: 'Balls'),
      DropZoneData(id: 'dz_car', acceptGroupId: 'car', label: 'Vehicles'),
    ],
  ),
  
  // LEVEL 6: Weather (Sun vs Rain)
    LevelData(
    levelNumber: 6,
    title: 'Weather Sort',
    instruction: 'Hot or Cold?',
    backgroundColor: const Color(0xFFE0F7FA),
    items: [
      GameItem(id: 'w1', groupId: 'hot', icon: Icons.wb_sunny, color: Colors.orange),
      GameItem(id: 'w2', groupId: 'cold', icon: Icons.ac_unit, color: Colors.lightBlue),
      GameItem(id: 'w3', groupId: 'hot', icon: Icons.local_fire_department, color: Colors.red),
      GameItem(id: 'w4', groupId: 'cold', icon: Icons.snowing, color: Colors.blueGrey),
    ],
    dropZones: [
      DropZoneData(id: 'dz_hot', acceptGroupId: 'hot', color: Colors.orange.shade100, label: 'Hot'),
      DropZoneData(id: 'dz_cold', acceptGroupId: 'cold', color: Colors.blue.shade100, label: 'Cold'),
    ],
  ),

    // LEVEL 7: Recycling
    LevelData(
    levelNumber: 7,
    title: 'Recycling',
    instruction: 'Paper vs Plastic',
    backgroundColor: const Color(0xFFF1F8E9),
    items: [
      GameItem(id: 'r1', groupId: 'paper', icon: Icons.newspaper, color: Colors.grey),
      GameItem(id: 'r2', groupId: 'plastic', icon: Icons.local_drink, color: Colors.blue),
      GameItem(id: 'r3', groupId: 'paper', icon: Icons.book, color: Colors.brown),
      GameItem(id: 'r4', groupId: 'plastic', icon: Icons.takeout_dining, color: Colors.transparent),
    ],
    dropZones: [
      DropZoneData(id: 'dz_paper', acceptGroupId: 'paper', color: Colors.brown.shade100, label: 'Paper'),
      DropZoneData(id: 'dz_plastic', acceptGroupId: 'plastic', color: Colors.blue.shade100, label: 'Plastic'),
    ],
  ),

      // LEVEL 8: Utensils
    LevelData(
    levelNumber: 8,
    title: 'Dinner Time',
    instruction: 'Set the table!',
    backgroundColor: const Color(0xFFFAFAFA),
    items: [
      GameItem(id: 'u1', groupId: 'fork', icon: Icons.restaurant, color: Colors.grey), // hacking restaurant icon
      GameItem(id: 'u2', groupId: 'spoon', icon: Icons.soup_kitchen, color: Colors.grey),
      GameItem(id: 'u3', groupId: 'fork', icon: Icons.restaurant, color: Colors.grey),
    ],
    dropZones: [
      DropZoneData(id: 'dz_fork', acceptGroupId: 'fork', label: 'Forks'),
      DropZoneData(id: 'dz_spoon', acceptGroupId: 'spoon', label: 'Spoons'),
    ],
  ),

     // LEVEL 9: Electronics vs Books
    LevelData(
    levelNumber: 9,
    title: 'Study Room',
    instruction: 'Gadgets vs Books',
    backgroundColor: const Color(0xFFECEFF1),
    items: [
      GameItem(id: 'e1', groupId: 'tech', icon: Icons.phone_iphone, color: Colors.black),
      GameItem(id: 'b1', groupId: 'book', icon: Icons.menu_book, color: Colors.blue),
      GameItem(id: 'e2', groupId: 'tech', icon: Icons.laptop, color: Colors.grey),
    ],
    dropZones: [
      DropZoneData(id: 'dz_tech', acceptGroupId: 'tech', label: 'Tech'),
      DropZoneData(id: 'dz_book', acceptGroupId: 'book', label: 'Books'),
    ],
  ),

       // LEVEL 10: The Ultimate Sort (3 categories)
    LevelData(
    levelNumber: 10,
    title: 'Ultimate Tidy',
    instruction: 'Sort Everything!',
    backgroundColor: const Color(0xFFF3E5F5),
    items: [
      GameItem(id: 'x1', groupId: 'star', icon: Icons.star, color: Colors.yellow),
      GameItem(id: 'x2', groupId: 'heart', icon: Icons.favorite, color: Colors.red),
      GameItem(id: 'x3', groupId: 'bolt', icon: Icons.bolt, color: Colors.orange),
      GameItem(id: 'x4', groupId: 'star', icon: Icons.star, color: Colors.yellow),
      GameItem(id: 'x5', groupId: 'heart', icon: Icons.favorite, color: Colors.pink),
    ],
    dropZones: [
      DropZoneData(id: 'dz_star', acceptGroupId: 'star', label: 'Stars'),
      DropZoneData(id: 'dz_heart', acceptGroupId: 'heart', label: 'Hearts'),
      DropZoneData(id: 'dz_bolt', acceptGroupId: 'bolt', label: 'Bolts'),
    ],
  ),
];
