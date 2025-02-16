import 'package:flutter/material.dart';
import 'control_panel_page.dart'; // ControlPanelPage için dosya
import 'robot_data_screen.dart';
import 'services/database_service.dart'; // DatabaseService sınıfınız için import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database; // Veritabanını başlat
  await DatabaseService.instance.addAdminsDirectly(); // Yöneticileri ekleyin
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    bool loginSuccess = await DatabaseService.instance.checkAdminLogin(email, password);
    if (loginSuccess) {
      // Giriş başarılı, ControlPanelPage ile başlayan MyApp widget'ını başlat
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ControlApp()));
    } else {
      final snackBar = SnackBar(content: Text('Email or password incorrect!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'assets/logo.jpeg', // Kullanacağınız logo
                  height: 150,
                ),
                SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail Address',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ControlApp extends StatefulWidget {
  @override
  _ControlAppState createState() => _ControlAppState();
}

class _ControlAppState extends State<ControlApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ControlPanelPage(),
    RobotDataScreen(), // Collected Data sayfası olarak
    // Diğer sayfalarınızı buraya ekleyebilirsiniz.
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Panel'),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Control Panel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Collected Data',
          ),
          // Diğer BottomNavigationBarItem'ları buraya ekleyin.
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}