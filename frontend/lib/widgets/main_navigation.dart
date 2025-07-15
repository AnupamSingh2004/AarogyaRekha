import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/risk_map_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/reports_analytics_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/field_work_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_help_screen.dart';

class MainNavigation extends StatefulWidget {
  final String userType;
  
  const MainNavigation({Key? key, required this.userType}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(userType: widget.userType),
      RiskMapScreen(userType: widget.userType),
      AlertsScreen(userType: widget.userType),
      ChatbotScreen(userType: widget.userType),
      ReportsAnalyticsScreen(userType: widget.userType),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? null : AppBar(
        backgroundColor: const Color(0xFF2E7D8A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildSideMenu(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2E7D8A),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Risk Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildUserSpecificMenuItems(),
          const Divider(),
          _buildGeneralMenuItems(),
          const Divider(),
          _buildSettingsMenuItems(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E7D8A),
            Color(0xFF1A5A6B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/logo/logo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          const Text(
            'AarogyaRekha',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          Text(
            _getUserTypeDisplayName(widget.userType),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSpecificMenuItems() {
    List<Widget> menuItems = [];
    
    switch (widget.userType) {
      case 'ASHA/ANM':
        menuItems.addAll([
          _buildMenuItem(Icons.work, 'Field Work', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => FieldWorkScreen(userType: widget.userType),
            ));
          }),
          _buildMenuItem(Icons.assignment, 'Case Management', () {
            _showFeatureComingSoon('Case Management');
          }),
          _buildMenuItem(Icons.school, 'Training Hub', () {
            _showFeatureComingSoon('Training Hub');
          }),
          _buildMenuItem(Icons.flash_on, 'Quick Actions', () {
            _showQuickActionsDialog();
          }),
        ]);
        break;
        
      case 'PHC':
        menuItems.addAll([
          _buildMenuItem(Icons.inventory, 'Resource Management', () {
            _showFeatureComingSoon('Resource Management');
          }),
          _buildMenuItem(Icons.group, 'Staff Coordination', () {
            _showFeatureComingSoon('Staff Coordination');
          }),
          _buildMenuItem(Icons.description, 'Admin Reports', () {
            _showFeatureComingSoon('Administrative Reports');
          }),
          _buildMenuItem(Icons.campaign, 'Campaign Planning', () {
            _showFeatureComingSoon('Campaign Planning');
          }),
        ]);
        break;
        
      case 'Rural':
        menuItems.addAll([
          _buildMenuItem(Icons.family_restroom, 'Family Health', () {
            _showFeatureComingSoon('Family Health');
          }),
          _buildMenuItem(Icons.home, 'Home Safety', () {
            _showFeatureComingSoon('Home Safety');
          }),
          _buildMenuItem(Icons.location_on, 'Local Resources', () {
            _showFeatureComingSoon('Local Resources');
          }),
          _buildMenuItem(Icons.book, 'Health Education', () {
            _showFeatureComingSoon('Health Education');
          }),
        ]);
        break;
        
      case 'Tourist':
        menuItems.addAll([
          _buildMenuItem(Icons.travel_explore, 'Travel Safety', () {
            _showFeatureComingSoon('Travel Safety');
          }),
          _buildMenuItem(Icons.route, 'Safe Routes', () {
            _showFeatureComingSoon('Safe Routes');
          }),
          _buildMenuItem(Icons.local_hospital, 'Emergency Services', () {
            _showFeatureComingSoon('Emergency Services');
          }),
          _buildMenuItem(Icons.vaccines, 'Health Prep', () {
            _showFeatureComingSoon('Health Preparation');
          }),
        ]);
        break;
    }
    
    return Column(children: menuItems);
  }

  Widget _buildGeneralMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.person, 'Profile', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProfileScreen(userType: widget.userType),
          ));
        }),
        _buildMenuItem(Icons.link, 'Integrations', () {
          _showFeatureComingSoon('Integrations');
        }),
        _buildMenuItem(Icons.health_and_safety, 'Gov Schemes', () {
          _showFeatureComingSoon('Government Health Schemes');
        }),
      ],
    );
  }

  Widget _buildSettingsMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.settings, 'Settings', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SettingsScreen(userType: widget.userType),
          ));
        }),
        _buildMenuItem(Icons.help, 'Help & Support', () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AboutHelpScreen(),
          ));
        }),
        _buildMenuItem(Icons.logout, 'Logout', () {
          _showLogoutDialog();
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF2E7D8A),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  String _getUserTypeDisplayName(String userType) {
    switch (userType) {
      case 'ASHA/ANM':
        return 'ASHA/ANM Worker';
      case 'PHC':
        return 'PHC/District Official';
      case 'Rural':
        return 'Rural Household';
      case 'Tourist':
        return 'Tourist';
      default:
        return 'User';
    }
  }

  void _showFeatureComingSoon(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(featureName),
        content: const Text('This feature is coming soon! Stay tuned for updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQuickActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Report Case'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('Report Case');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.blue),
              title: const Text('Request Supplies'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('Request Supplies');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency, color: Colors.orange),
              title: const Text('Emergency Contacts'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('Emergency Contacts');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout functionality will be implemented'),
                  backgroundColor: Color(0xFF2E7D8A),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
