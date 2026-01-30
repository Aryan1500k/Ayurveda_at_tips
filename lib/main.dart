import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  void _initialization() async {
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
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9F4),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Playfair Display', fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          headlineMedium: TextStyle(fontFamily: 'Playfair Display', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF8B6B23)),
          bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8B6B23),
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
            if (user == null) return const AuthScreen();
            return MainNavigationWrapper(
              onThemeChanged: _toggleTheme,
              isDarkMode: _themeMode == ThemeMode.dark,
            );
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF8B6B23))));
        },
      ),
      routes: {'/auth': (context) => const AuthScreen()},
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const MainNavigationWrapper({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
              // SIGN OUT FROM BOTH
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();

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

  @override
  Widget build(BuildContext context) {
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
      ProductScreen(onTalkToExpert: () => _onItemTapped(3)),
      const ExpertScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // --- COLLAPSING/STICKY LOGO HEADER ---
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true, // This makes the logo sticky at the top
              centerTitle: true,
              elevation: 0,
              backgroundColor: widget.isDarkMode ? Colors.black : const Color(0xFFF8F9F4),
              iconTheme: IconThemeData(color: widget.isDarkMode ? Colors.white : Colors.black),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "AYURVEDA",
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 18,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6344),
                    ),
                  ),
                  const Text(
                    "AT TIPS",
                    style: TextStyle(letterSpacing: 1, fontSize: 8, color: Colors.grey),
                  ),
                ],
              ),
              // Shopping Cart Icon on the right
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ];
        },
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      drawer: Drawer(
        backgroundColor: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9F4),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFFEFAF2)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.spa_outlined, size: 40, color: Color(0xFF8B6B23)),
                    const SizedBox(height: 10),
                    const Text(
                      "AYURVEDA",
                      style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF8B6B23), fontSize: 18),
                    ),
                    const Text("AT TIPS", style: TextStyle(letterSpacing: 1, fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.home_outlined, "Home", tabIndex: 0),
            _buildDrawerItem(Icons.person_outline, "Profile", tabIndex: 4),
            _buildDrawerItem(Icons.notifications_none, "Notifications", destinationPage: const NotificationScreen()),
            _buildDrawerItem(
              Icons.settings_outlined,
              "Settings",
              destinationPage: SettingsScreen(onThemeChanged: widget.onThemeChanged, isDark: widget.isDarkMode),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(color: Colors.black12)),
            _buildDrawerItem(Icons.help_outline, "Help", destinationPage: const HelpScreen()),
            _buildDrawerItem(Icons.info_outline, "About", destinationPage: const AboutScreen()),
            const Spacer(),
            _buildDrawerItem(Icons.logout, "Logout", isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8B6B23), // Matches the brown theme
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
    const Color themeBrown = Color(0xFF8B6B23);
    bool isNotification = title == "Notifications";

    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : themeBrown),
      title: Row(
        children: [
          Text(title, style: TextStyle(color: isLogout ? Colors.red : (widget.isDarkMode ? Colors.white : Colors.black87), fontWeight: FontWeight.w500)),
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
                  child: Text("$unreadCount", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                );
              },
            ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
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
}