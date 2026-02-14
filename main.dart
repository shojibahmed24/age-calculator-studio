import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

// --- MODELS ---
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0) String title;
  @HiveField(1) String content;
  @HiveField(2) DateTime date;
  Note({required this.title, required this.content, required this.date});
}

// --- AD SERVICE ---
class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _canShowAd = false;
  static int _toolUseCount = 0;

  static void init() {
    MobileAds.instance.initialize();
    // 30s delay for first ad
    Timer(Duration(seconds: 30), () => _canShowAd = true);
    _loadInterstitial();
  }

  static void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  static void showInterstitialOnLogic() {
    _toolUseCount++;
    if (_canShowAd && (_toolUseCount % 2 == 0 || _interstitialAd != null)) {
      _interstitialAd?.show();
      _loadInterstitial();
      _canShowAd = false;
      Timer(Duration(seconds: 75), () => _canShowAd = true);
    }
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  AdService.init();
  runApp(ChangeNotifierProvider(create: (_) => ThemeProvider(), child: SmartToolsApp()));
}

class SmartToolsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.themeMode,
      home: DashboardScreen(),
    );
  }
}

// --- DASHBOARD (Bento Grid) ---
class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tools = [
    {'name': 'Calculator', 'icon': Icons.calculate, 'color': Colors.blue},
    {'name': 'Age Calc', 'icon': Icons.calendar_today, 'color': Colors.orange},
    {'name': 'Notes', 'icon': Icons.note_alt, 'color': Colors.green},
    {'name': 'BMI', 'icon': Icons.speed, 'color': Colors.red},
    {'name': 'Unit Conv', 'icon': Icons.ac_unit, 'color': Colors.purple},
    {'name': 'Password', 'icon': Icons.lock, 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart All-in-One'), actions: [IconButton(icon: Icon(Icons.settings), onPressed: (){})]),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: tools.length,
              itemBuilder: (context, index) => _buildBentoCard(context, tools[index]),
            ),
          ),
          _buildBannerAd(),
        ],
      ),
    );
  }

  Widget _buildBentoCard(BuildContext context, Map<String, dynamic> tool) {
    return InkWell(
      onTap: () {
        AdService.showInterstitialOnLogic();
        // Navigate to tool...
      },
      child: Container(
        decoration: BoxDecoration(color: tool['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(24), border: Border.all(color: tool['color'].withOpacity(0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(tool['icon'], size: 40, color: tool['color']),
          SizedBox(height: 8),
          Text(tool['name'], style: TextStyle(fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  Widget _buildBannerAd() {
    return Container(
      height: 50, 
      width: double.infinity, 
      color: Colors.grey[200], 
      child: Center(child: Text('Banner Ad Area (Test ID: ...78111)'))
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  void toggleTheme() { themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light; notifyListeners(); }
}