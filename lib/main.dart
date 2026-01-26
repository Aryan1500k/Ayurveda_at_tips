import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';

// --- Screen Imports ---
import 'home_screen.dart';
import 'models/app_notification.dart';
import 'notification_service.dart';
import 'quiz_intro_screen.dart';
import 'product_screen.dart';
import 'expert_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'auth_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // 1. Initialize and Preserve Native Splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Start notification service
  await NotificationService().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _initialization();
  }

  // 2. Logic to remove splash screen after initialization
  void _initialization() async {
    // Keeps the splash screen visible for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Ayurveda At Tips',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF009460),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF009460),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
      ),
      themeMode: _themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const AuthScreen();
            }
            return MainNavigationWrapper(
                onThemeChanged: _toggleTheme,
                isDarkMode: _themeMode == ThemeMode.dark
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF009460))),
          );
        },
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const MainNavigationWrapper({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  // Helper function to switch tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Updated _pages with full navigation logic for the new Home UI
    final List<Widget> _pages = [
      HomeScreen(
        onDiscoverDosha: () => _onItemTapped(1),
        onExploreProducts: () => _onItemTapped(2),
        onTalkToExpert: () => _onItemTapped(3),
      ),
      QuizIntroScreen(
        onViewPlan: () => _onItemTapped(2),
        onConsultExpert: () => _onItemTapped(3),
      ),
      // UPDATE THIS LINE:
      ProductScreen(onTalkToExpert: () => _onItemTapped(3)),

      const ExpertScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayurveda At Tips"),
        elevation: 0,
      ),
            // --- DRAWER HEADER ---
        drawer: Drawer(
        backgroundColor: const Color(0xFFF8F9F4), // Set sidebar background color
        child: Column(
          children: [
            // --- UPDATED HEADER SECTION ---
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFFEFAF2), // Soft beige background
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CHANGE: Using the brown spa icon instead of an image asset
                    const Icon(
                      Icons.spa_outlined,
                      size: 40,
                      color: Color(0xFF8B6B23),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "AYURVEDA",
                      style: TextStyle(
                        fontFamily: 'Trajan Pro',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Color(0xFF8B6B23), // Theme brown color
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "AT TIPS",
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- DRAWER ITEMS (Maintained Navigation) ---
            _buildDrawerItem(Icons.home_outlined, "Home", tabIndex: 0),
            _buildDrawerItem(Icons.person_outline, "Profile", tabIndex: 4),
            _buildDrawerItem(Icons.notifications_none, "Notifications", destinationPage: const NotificationScreen()),

            _buildDrawerItem(
              Icons.settings_outlined,
              "Settings",
              destinationPage: SettingsScreen(
                onThemeChanged: widget.onThemeChanged,
                isDark: widget.isDarkMode,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.black12),
            ),

            _buildDrawerItem(Icons.help_outline, "Help", destinationPage: const HelpScreen()),
            _buildDrawerItem(Icons.info_outline, "About", destinationPage: const AboutScreen()),

            const Spacer(),

            // --- LOGOUT ITEM ---
            _buildDrawerItem(Icons.logout, "Logout", isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // 5. Updated BottomNavigationBar with 5 items
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF009460),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Quiz"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Expert"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
    }

  Widget _buildDrawerItem(IconData icon, String title, {int? tabIndex, Widget? destinationPage, bool isLogout = false}) {
    // Define your theme color here
    const Color themeBrown = Color(0xFF8B6B23);
    bool isNotification = title == "Notifications";

    return ListTile(
      leading: Icon(
        icon,
        // CHANGE: This line ensures icons are brown, except for Logout
        color: isLogout ? Colors.red : themeBrown,
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isLogout ? Colors.red : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          // --- KEPT NOTIFICATION BADGE LOGIC ---
          if (isNotification)
            ValueListenableBuilder<List<AppNotification>>(
              valueListenable: notificationNotifier,
              builder: (context, notifications, child) {
                int unreadCount = notifications.where((n) => !n.isRead).length;
                if (unreadCount == 0) return const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text("$unreadCount",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                );
              },
            ),
        ],
      ),
      onTap: () {
        // --- KEPT NAVIGATION LOGIC ---
        Navigator.pop(context); // Close the drawer
        if (isLogout) {
          _showLogoutDialog();
        } else if (tabIndex != null) {
          _onItemTapped(tabIndex);
        } else if (destinationPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
        }
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/auth');
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}