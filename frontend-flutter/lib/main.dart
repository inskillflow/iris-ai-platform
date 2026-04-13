import 'package:flutter/material.dart';
import 'screens/prediction_screen.dart';
import 'screens/model_info_screen.dart';
import 'screens/dataset_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const IrisApp());
}

class IrisApp extends StatelessWidget {
  const IrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iris ML Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF667eea),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _apiConnected = false;
  final _apiService = ApiService();

  final _screens = const [
    PredictionScreen(),
    ModelInfoScreen(),
    DatasetScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    final connected = await _apiService.healthCheck();
    setState(() => _apiConnected = connected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_florist),
            SizedBox(width: 8),
            Text('Iris ML Demo'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: Icon(
                _apiConnected ? Icons.cloud_done : Icons.cloud_off,
                size: 18,
                color: _apiConnected ? Colors.green : Colors.red,
              ),
              label: Text(
                _apiConnected ? 'API connectée' : 'API hors ligne',
                style: TextStyle(
                  fontSize: 12,
                  color: _apiConnected ? Colors.green : Colors.red,
                ),
              ),
              backgroundColor: _apiConnected
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Prédiction',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Modèle',
          ),
          NavigationDestination(
            icon: Icon(Icons.dataset_outlined),
            selectedIcon: Icon(Icons.dataset),
            label: 'Dataset',
          ),
        ],
      ),
    );
  }
}
