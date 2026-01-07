import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // REQUIRED for User and FirebaseAuth
import 'firebase_options.dart';

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
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayurveda At Tips',
      theme: ThemeData(
        primaryColor: const Color(0xFF009460),
        useMaterial3: true,
      ),
      // --- This StreamBuilder handles auto-login ---
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot has user data, the user is logged in
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const AuthScreen(); // User is NOT logged in
            }
            return const MainNavigationWrapper(); // User IS logged in
          }
          // Show a loading spinner while checking auth status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF009460))),
          );
        },
      ),
      // --- Define routes for Logout navigation ---
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigationWrapper(),
      },
    );
  }
}

// --- Your Main Navigation Logic ---
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
      appBar: AppBar(
        title: const Text("Ayurveda At Tips"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFE8F3EE)),
              child: const Center(
                child: Text("AYURVEDA At Tips",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF009460))),
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
      title: Text(title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          )),
      onTap: () {
        Navigator.pop(context); // Close Drawer
        if (isLogout) {
          _showLogoutDialog();
        } else if (tabIndex != null) {
          setState(() {
            _selectedIndex = tabIndex;
          });
        } else if (destinationPage != null) {
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
              onPressed: () async {
                // Return to Auth screen on logout
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/auth');
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}