import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNT Manager',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD4AF37),
          surface: const Color(0xFF0F0F1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');
    final expiryDate = prefs.getString('expiryDate');
    final mikrotikUrl = prefs.getString('mikrotikUrl');

    await Future.delayed(const Duration(seconds: 2));

    if (phone != null && expiryDate != null && mikrotikUrl != null) {
      final expiry = DateTime.parse(expiryDate);
      if (expiry.isAfter(DateTime.now())) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(url: mikrotikUrl),
          ),
        );
        return;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield,
                size: 70,
                color: Color(0xFF0F0F1A),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'SNT Manager',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
                letterSpacing: 2,
              ),
            ),
            const Text(
              'Sultan Network Tool',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Color(0xFFD4AF37),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mikrotikUrlController = TextEditingController();
  final TextEditingController _mikrotikUserController = TextEditingController();
  final TextEditingController _mikrotikPassController = TextEditingController();
  bool _isLoading = false;

  Future<void> _activateSubscription() async {
    if (_phoneController.text.isEmpty || _mikrotikUrlController.text.isEmpty) {
      _showMessage('يرجى ملء جميع الحقول');
      return;
    }

    setState(() => _isLoading = true);

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showMessage('لا يوجد اتصال بالانترنت');
      setState(() => _isLoading = false);
      return;
    }

    final expiryDate = DateTime.now().add(const Duration(days: 30));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('expiryDate', expiryDate.toIso8601String());
    await prefs.setString('mikrotikUrl', _mikrotikUrlController.text);
    await prefs.setString('mikrotikUser', _mikrotikUserController.text);
    await prefs.setString('mikrotikPass', _mikrotikPassController.text);
    await prefs.setString('role', 'admin');

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: _mikrotikUrlController.text),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNT Manager - تفعيل الاشتراك'),
        backgroundColor: const Color(0xFF0F0F1A),
        foregroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield, size: 50, color: Color(0xFFD4AF37)),
                  const SizedBox(height: 10),
                  const Text(
                    'SNT Manager',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _mikrotikUrlController,
              decoration: InputDecoration(
                labelText: 'رابط Mikrotik',
                hintText: 'http://192.168.88.1',
                prefixIcon: const Icon(Icons.link, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _mikrotikUserController,
              decoration: InputDecoration(
                labelText: 'اسم مستخدم Mikrotik',
                prefixIcon: const Icon(Icons.person, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _mikrotikPassController,
              decoration: InputDecoration(
                labelText: 'كلمة مرور Mikrotik',
                prefixIcon: const Icon(Icons.lock, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  )
                : ElevatedButton(
                    onPressed: _activateSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'تفعيل الاشتراك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
            const SizedBox(height: 15),
            const Text(
              'الاشتراك التجريبي 30 يوم',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _phone = '';
  String _expiryDate = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phone = prefs.getString('phone') ?? '';
      _expiryDate = prefs.getString('expiryDate') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
      );
    }
  }

  void _showSubscriptionInfo() {
    final expiry = DateTime.parse(_expiryDate);
    final daysLeft = expiry.difference(DateTime.now()).inDays;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'معلومات الاشتراك',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم الهاتف: $_phone',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'الايام المتبقية: $daysLeft يوم',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'تاريخ الانتهاء: ${expiry.day}/${expiry.month}/${expiry.year}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNT Manager'),
        backgroundColor: const Color(0xFF0F0F1A),
        foregroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            onPressed: _showSubscriptionInfo,
            icon: const Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Color(0xFFD4AF37)),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: const Color(0xFF0F0F1A),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
