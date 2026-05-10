import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        fontFamily: 'Cairo',
      ),
      home: const InitialCheckScreen(),
    );
  }
}

// شاشة الفحص الأولي: هل المستخدم جديد أم لديه رمز؟
class InitialCheckScreen extends StatefulWidget {
  const InitialCheckScreen({super.key});

  @override
  State<InitialCheckScreen> createState() => _InitialCheckScreenState();
}

class _InitialCheckScreenState extends State<InitialCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  _checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pin = prefs.getString('user_pin');

    // تأخير بسيط لشكل جمالي
    await Future.delayed(const Duration(seconds: 2));

    if (pin == null) {
      // مستخدم جديد -> شاشة إعداد الرمز
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SetupPinScreen()));
    } else {
      // مستخدم مسجل -> شاشة إدخال الرمز
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginPinScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
      ),
    );
  }
}

// شاشة إعداد الرمز لأول مرة
class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();

  _savePin() async {
    if (pin1.text.length == 4 && pin1.text == pin2.text) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pin', pin1.text);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("الرموز غير متطابقة أو ناقصة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("إعداد الرمز السري لأول مرة",
                style: TextStyle(color: Color(0xFFD4AF37), fontSize: 22)),
            const SizedBox(height: 30),
            TextField(
                controller: pin1,
                decoration:
                    const InputDecoration(hintText: "أدخل رمز من 4 أرقام"),
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4),
            TextField(
                controller: pin2,
                decoration:
                    const InputDecoration(hintText: "تأكيد الرمز السري"),
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _savePin, child: const Text("حفظ وتفعيل"))
          ],
        ),
      ),
    );
  }
}

// شاشة الدخول بالرمز
class LoginPinScreen extends StatefulWidget {
  const LoginPinScreen({super.key});

  @override
  State<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends State<LoginPinScreen> {
  final TextEditingController pinController = TextEditingController();

  _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('user_pin');
    if (pinController.text == savedPin) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("الرمز خاطئ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("STN_Manager",
                style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: TextField(
                  controller: pinController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  style: const TextStyle(fontSize: 24, letterSpacing: 15)),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: _login,
                child: const Text("دخول",
                    style: TextStyle(fontSize: 20, color: Color(0xFFD4AF37)))),
            TextButton(
                onPressed: () {},
                child: const Text("نسيت الرمز؟",
                    style: TextStyle(color: Colors.white54))),
          ],
        ),
      ),
    );
  }
}

// لوحة التحكم (الرئيسية)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مدير الشبكة"), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          _card(Icons.router, "برودباند"),
          _card(Icons.wifi, "هوتسبوت"),
          _card(Icons.sensors, "قطع البث"),
          _card(Icons.print, "الكروت"),
          _card(Icons.analytics, "تقارير"),
          _card(Icons.settings, "إعدادات"),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1B),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 40),
        const SizedBox(height: 10),
        Text(label)
      ]),
    );
  }
}
