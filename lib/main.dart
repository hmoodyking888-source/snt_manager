import 'package:flutter/material.dart';

void main() {
  runApp(const STNManagerApp());
}

class STNManagerApp extends StatelessWidget {
  const STNManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sultan Net',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const LoginPage(),
    );
  }
}

// شاشة الدخول
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined,
                size: 100, color: Color(0xFFD4AF37)),
            const SizedBox(height: 10),
            const Text("Sultan Net Manager",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37))),
            const SizedBox(height: 40),
            TextField(
                controller: user,
                decoration: const InputDecoration(
                    labelText: "اسم المستخدم", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(
                controller: pass,
                decoration: const InputDecoration(
                    labelText: "كلمة المرور", border: OutlineInputBorder()),
                obscureText: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37)),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const DashboardPage())),
                child: const Text("دخول للنظام",
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

// لوحة التحكم الرئيسية (مدير الشبكة)
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
          _card(
              context,
              Icons.router,
              "برودباند",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const AccountsPage(title: "برودباند")))),
          _card(
              context,
              Icons.wifi,
              "هوتسبوت",
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const AccountsPage(title: "هوتسبوت")))),
          _card(context, Icons.sensors, "قطع البث", () {}),
          _card(context, Icons.print, "الكروت", () {}),
          _card(context, Icons.settings, "إعدادات السيرفر",
              () => _showServerSettings(context)),
          _card(context, Icons.analytics, "تقارير", () {}),
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
          Icon(icon, color: const Color(0xFFD4AF37), size: 40),
          const SizedBox(height: 10),
          Text(label)
        ]),
      ),
    );
  }

  void _showServerSettings(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (c) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                const Text("إعدادات الاتصال بميكروتك",
                    style: TextStyle(fontSize: 18, color: Color(0xFFD4AF37))),
                const TextField(
                    decoration: InputDecoration(
                        hintText: "IP السيرفر (مثل 192.168.1.1)")),
                const TextField(
                    decoration:
                        InputDecoration(hintText: "اسم مستخدم ميكروتك")),
                const TextField(
                    decoration: InputDecoration(hintText: "باسورد ميكروتك"),
                    obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("حفظ البيانات"))
              ]),
            ));
  }
}

// شاشة الحسابات المتكاملة (التي ظهر فيها الخطأ سابقاً وتم تصحيحه)
class AccountsPage extends StatelessWidget {
  final String title;
  const AccountsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(title), backgroundColor: const Color(0xFF673AB7)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFF2D2D2D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statusChip("الكل", Colors.grey),
                _statusChip("نشط", Colors.green),
                _statusChip("نائم", Colors.pink),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) =>
                  _userTile("مشترك سلطان نت $index"),
            ),
          ),
        ],
      ),
    );
  }

  // تم إزالة كلمة const من هنا لأن الألوان والبارامترات متغيرة (حل المشكلة)
  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _userTile(String name) {
    return ListTile(
      leading: const Icon(Icons.person, color: Color(0xFFD4AF37)),
      title: Text(name),
      subtitle: const Text("IP: 10.10.x.x | Speed: 2M"),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
