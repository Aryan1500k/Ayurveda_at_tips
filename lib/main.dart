import 'package:flutter/material.dart';

// --- Screen Imports ---
import 'home_screen.dart';
import 'quiz_intro_screen.dart';
import 'product_screen.dart';
import 'expert_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';

void main() {
  runApp(const AyurvedaApp());
}

class AyurvedaApp extends StatelessWidget {
  const AyurvedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primaryColor: const Color(0xFF009460),

        // --- CHANGE 1: GLOBAL PISTACHIO BACKGROUND ---
        scaffoldBackgroundColor: const Color(0xFFE8F3EE),

        // --- CHANGE 2: TRANSPARENT APP BAR ---
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Blends with pistachio background
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const QuizIntroScreen(),
    const ProductScreen(),
    const ExpertScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar now uses the transparent theme automatically
      appBar: AppBar(
        title: const Text(""),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFE8F3EE)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text("AYURVEDA At Tips", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ],
                ),
              ),
            ),

            _buildDrawerItem(Icons.home_outlined, "Home", tabIndex: 0),
            _buildDrawerItem(Icons.person_outline, "Profile", destinationPage: const ProfileScreen()),
            _buildDrawerItem(Icons.notifications_none, "Notifications", destinationPage: const NotificationScreen()),
            _buildDrawerItem(Icons.settings_outlined, "Settings", destinationPage: const SettingsScreen()),

            const Divider(),

            _buildDrawerItem(Icons.help_outline, "Help", destinationPage: const HelpScreen()),
            _buildDrawerItem(Icons.info_outline, "About", destinationPage: const AboutScreen()),

            const Spacer(),

            _buildDrawerItem(Icons.logout, "Logout", isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF009460),
        unselectedItemColor: Colors.grey,
        // Match the bottom bar to the background for a cleaner look
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Dosha Quiz"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Expert"),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {int? tabIndex, Widget? destinationPage, bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF009460)),
      title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          )
      ),
      onTap: () {
        Navigator.pop(context);

        if (isLogout) {
          _showLogoutDialog();
        }
        else if (tabIndex != null) {
          setState(() {
            _selectedIndex = tabIndex;
          });
        }
        else if (destinationPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        }
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Logout", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}