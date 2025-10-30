import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mini4wd_store/controller/auth_controller.dart';
import 'package:mini4wd_store/controller/currency_controller.dart';
import 'package:mini4wd_store/controller/timezone_controller.dart';
import 'package:mini4wd_store/service/session_service.dart';
import 'package:mini4wd_store/ui/style/colors.dart';
import 'package:mini4wd_store/ui/theme/app_theme.dart';
import 'package:mini4wd_store/views/home_view.dart';
import 'package:mini4wd_store/views/login_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL').toString(),
    anonKey: dotenv.get("SUPABASE_ANON_KEY").toString(),
  );

  // initialize Time Zone Controller
  Get.put(TimezoneController());
  Get.put(CurrencyController());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final sessionService = SessionService();
  Widget? _startPage;

  @override
  void initState() {
    super.initState();
     Get.lazyPut(() => AuthController());
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = await sessionService.loadSession();

    setState(() {
      if (session != null && session['email'] != null) {
        _startPage = HomeView();
      } else {
        _startPage = LoginView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home:
          _startPage ??
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mini Dash", style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue
                  ),),
                  SizedBox(height: 10,),
                  CircularProgressIndicator()
                ],
              ))
            ),
    );
  }
}
