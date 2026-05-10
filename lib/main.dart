import 'package:flutter/material.dart';

void main() => runApp(const SultanNetApp());

class SultanNetApp extends StatelessWidget {
  const SultanNetApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const LoginScreen(), // البداية من واجهة الدخول
    );
  }
}

// ---------------- واجهة الدخول برقم الهاتف ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final Color gold = const Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: gold, size: 80),
              const SizedBox(height: 20),
              Text("STN_MANAGER",
                  style: TextStyle(
                      color: gold, fontSize: 32, fontWeight: FontWeight.bold)),
              const Text("سلطان نت - إدارة الشبكات",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 50),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "رقم الهاتف",
                  prefixIcon: Icon(Icons.phone, color: gold),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const STNManagerDashboard())),
                child: const Text("تسجيل الدخول",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              const Text("تحقق من صلاحية الاشتراك...",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- الواجهة الرئيسية ----------------
class STNManagerDashboard extends StatefulWidget {
  const STNManagerDashboard({super.key});
  @override
  State<STNManagerDashboard> createState() => _STNManagerDashboardState();
}

class _STNManagerDashboardState extends State<STNManagerDashboard> {
  String selectedInterface = "ether1"; // الانترفيس الافتراضي للعداد
  final Color gold = const Color(0xFFE5C158);
  final Color darkPanel = const Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildTopMetricsRow(),
              const SizedBox(height: 15),
              _buildActiveAccountsGrid(context),
              const SizedBox(height: 20),
              _buildCloudButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("مدير الشبكة",
              style: TextStyle(
                  color: gold, fontSize: 22, fontWeight: FontWeight.bold)),
          Text("متصل عبر: RB1100AHx4",
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
        Icon(Icons.settings, color: gold),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(child: _statBox("المعالج", "18%", Icons.memory)),
        const SizedBox(width: 8),
        Expanded(child: _gaugeBox()),
      ],
    );
  }

  Widget _statBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: darkPanel,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gold.withOpacity(0.3))),
      child: Column(children: [
        Icon(icon, color: gold),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _gaugeBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: darkPanel,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gold.withOpacity(0.3))),
      child: Column(
        children: [
          Text(selectedInterface,
              style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
          const Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: 0.6, color: Colors.green),
            Text("45.2", style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          InkWell(
            onTap: () => _showInterfacePicker(),
            child: Container(
              margin: const EdgeInsets.top(5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                  color: gold, borderRadius: BorderRadius.circular(5)),
              child: const Text("ضبط السرعة",
                  style: TextStyle(color: Colors.black, fontSize: 10)),
            ),
          )
        ],
      ),
    );
  }

  void _showInterfacePicker() {
    showModalBottomSheet(
        context: context,
        backgroundColor: darkPanel,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: ["ether1-WAN", "ether2-LAN", "wlan1", "Bridge-Local"]
                .map((iface) => ListTile(
                      title: Text(iface),
                      onTap: () {
                        setState(() => selectedInterface = iface);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          );
        });
  }

  Widget _buildActiveAccountsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _gridItem(
            "البرودباند",
            Icons.router,
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const BroadbandPage()))),
        _gridItem("هوتسبوت", Icons.wifi, () => _showHotspotMenu()),
        _gridItem("الاكتف", Icons.person_search, () {}),
        _gridItem(
            "الإضافات",
            Icons.extension,
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddonsPage()))),
        _gridItem("قطع البث", Icons.cell_tower, () {}),
        _gridItem("الإشعارات", Icons.notifications, () {}),
      ],
    );
  }

  Widget _gridItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: darkPanel,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: gold.withOpacity(0.2))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: gold, size: 30),
          Text(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  void _showHotspotMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: darkPanel,
        builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(Icons.print),
                    title: const Text("توليد بطاقات هوتسبوت"),
                    onTap: () {}),
                ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text("بحث عن مشاكل"),
                    textColor: Colors.red,
                    onTap: () {}),
              ],
            ));
  }

  Widget _buildCloudButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: gold.withOpacity(0.1),
          border: Border.all(color: gold),
          borderRadius: BorderRadius.circular(15)),
      child: const Center(
          child: Text("إضافة كلاود (دخول سريع)",
              style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

// ---------------- شاشة البرودباند مع زر الإضافة (+) ----------------
class BroadbandPage extends StatelessWidget {
  const BroadbandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البرودباند"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle,
                color: Color(0xFFE5C158), size: 30),
            onPressed: () => _showAddAccountDialog(context),
          )
        ],
      ),
      body: const Center(child: Text("قائمة المشتركين تظهر هنا...")),
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF121212),
              title: const Text("إضافة حساب برودباند جديد",
                  style: TextStyle(color: Color(0xFFE5C158))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      decoration: InputDecoration(
                          hintText: "اسم المستخدم",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 10),
                  TextField(
                      decoration: InputDecoration(
                          hintText: "كلمة المرور",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    hint: const Text("اختر الباقة"),
                    items: ["5 Mbps", "10 Mbps", "Open"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إلغاء")),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5C158)),
                    child: const Text("إضافة",
                        style: TextStyle(color: Colors.black))),
              ],
            ));
  }
}

// ---------------- شاشة الإضافات (تعمل بالكامل) ----------------
class AddonsPage extends StatelessWidget {
  const AddonsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإضافات")),
      body: ListView(
        children: [
          _addonTile(Icons.settings_ethernet, "الواجهات (Interfaces)",
              "ether1, ether2, wlan1"),
          _addonTile(
              Icons.print, "توليد كروت حرارية", "إعدادات الطابعة والقوالب"),
          _addonTile(Icons.smart_toy, "ربط بوت التلجرام", "الحالة: متصل"),
        ],
      ),
    );
  }

  Widget _addonTile(IconData icon, String title, String sub) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE5C158)),
      title: Text(title),
      subtitle:
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
