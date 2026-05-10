import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ملاحظة: تأكد من إضافة ملف google-services.json في مجلد android/app
  // سنقوم بتفعيل Firebase هنا
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
      home: const LoginPinScreen(),
    );
  }
}

// شاشة الدخول المحدثة برقم الهاتف والـ PIN
class LoginPinScreen extends StatefulWidget {
  const LoginPinScreen({super.key});

  @override
  State<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends State<LoginPinScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://i.imgur.com/your_logo_id.png',
                height: 120,
                errorBuilder: (c, e, s) => const Icon(Icons.shield,
                    size: 100, color: Color(0xFFD4AF37))),
            const SizedBox(height: 20),
            const Text("SNT Manager",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37))),
            const Text("Sultan Network Tool",
                style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 50),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: "رقم الهاتف",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pinController,
              decoration: InputDecoration(
                  hintText: "الرمز السري",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage())),
                child: const Text("تسجيل الدخول",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// لوحة التحكم الرئيسية المحدثة
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("مدير الشبكة"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          _card(
              context,
              Icons.router,
              "برودباند",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountsPage()))),
          _card(context, Icons.wifi, "هوتسبوت", () {}),
          _card(context, Icons.sensors, "قطع البث", () {}),
          _card(context, Icons.print, "الكروت", () {}),
          _card(context, Icons.analytics, "تقارير", () {}),
          _card(context, Icons.settings, "إعدادات", () {}),
        ],
      ),
    );
  }

  Widget _card(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1B),
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 45),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 16))
        ]),
      ),
    );
  }
}

// شاشة حسابات البرودباند (المستوحاة من الصورة التي أرسلتها)
class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("حسابات برودباند"),
        backgroundColor:
            const Color(0xFF673AB7), // اللون الأرجواني كما في صورتك
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          // شريط الحالة العلوي
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFF2D2D2D),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statusChip("الكل (51)", Colors.grey),
                _statusChip("نشط (33)", Colors.green),
                _statusChip("نائم (13)", Colors.pink),
              ],
            ),
          ),
          // قائمة المشتركين
          Expanded(
            child: ListView.builder(
              itemCount: 10, // تجريبي
              itemBuilder: (context, index) {
                return _userTile(context, "حمود الفتيح $index",
                    index % 2 == 0 ? "نشط" : "نائم");
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _userTile(BuildContext context, String name, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 40, color: Colors.blueGrey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(status == "نشط" ? "متصل - 2M" : "أخر ظهور منذ ساعة",
                    style: TextStyle(
                        color: status == "نشط" ? Colors.green : Colors.grey,
                        fontSize: 12)),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text("قطع الاتصال")),
              const PopupMenuItem(child: Text("تعديل السرعة")),
              const PopupMenuItem(child: Text("حذف")),
            ],
          ),
        ],
      ),
    );
  }
}
