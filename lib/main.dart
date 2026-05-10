import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const STNManagerApp());
}

class STNManagerApp extends StatelessWidget {
  const STNManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STN_Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFD4AF37),
        ),
        fontFamily: 'Cairo',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController phoneController = TextEditingController();

  // وظيفة البصمة
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'يرجى تأكيد البصمة للدخول إلى STN_Manager',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print(e);
    }
    if (authenticated) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1A1A1B), Color(0xFF000000)],
            radius: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعار الذهبي
            const Text(
              "STN_Manager",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37)),
            ),
            const Text("إدارة شبكة سلطان نت",
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 60),

            // حقل رقم الهاتف
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "أدخل رقم الهاتف للتفعيل",
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // زر الدخول بالبصمة
            InkWell(
              onTap: _authenticate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                ),
                child: const Icon(Icons.fingerprint,
                    size: 60, color: Color(0xFFD4AF37)),
              ),
            ),
            const SizedBox(height: 10),
            const Text("اضغط لتأكيد البصمة",
                style: TextStyle(color: Color(0xFFD4AF37))),

            const SizedBox(height: 40),

            // زر التفعيل/الدخول
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage())),
                child: const Text("دخول للنظام",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة لوحة التحكم (الرئيسية)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مدير الشبكة",
            style: TextStyle(color: Color(0xFFD4AF37))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildMenuCard(Icons.router, "برودباند"),
          _buildMenuCard(Icons.wifi, "متصلون هوتسبوت"),
          _buildMenuCard(Icons.sensors, "قطع البث"),
          _buildMenuCard(Icons.print, "طباعة كروت"),
          _buildMenuCard(Icons.analytics, "التقارير"),
          _buildMenuCard(Icons.settings, "الإعدادات"),
        ],
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 45, color: const Color(0xFFD4AF37)),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
