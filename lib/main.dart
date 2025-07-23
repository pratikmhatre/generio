import 'package:flutter/material.dart';
import 'package:generio/pages/dashboard.dart';
import 'package:generio/pages/settings.dart';
import 'package:generio/utils/notifiers.dart';
import 'package:generio/utils/shared_prefs_provider.dart';
import 'package:lottie/lottie.dart';

void main() async {
  await SharedPrefsProvider().init();
  runApp(const GenerioApp());
}

class GenerioApp extends StatelessWidget {
  const GenerioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: SafeArea(child: scaffoldBody())),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
    );
  }

  Widget scaffoldBody() {
    return ValueListenableBuilder(
      valueListenable: pagePositionNotifier,
      builder: (context, value, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.00,
                  vertical: 50.00,
                ),
                color: Colors.blueAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Lottie.asset('assets/lottie/coding.json'),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    InkWell(
                      onTap: () {
                        pagePositionNotifier.value = PageName.HOME;
                      },
                      child: ListTile(
                        leading: Icon(
                          value == PageName.HOME
                              ? Icons.home_filled
                              : Icons.home_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Divider(thickness: 0.5, color: Colors.white),
                    InkWell(
                      onTap: () {
                        pagePositionNotifier.value = PageName.SETTINGS;
                      },
                      child: ListTile(
                        leading: Icon(
                          value == PageName.SETTINGS
                              ? Icons.settings
                              : Icons.settings_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Settings',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Stack(
                children: [
                  Offstage(
                    offstage: value != PageName.HOME,
                    child: DashboardPage(),
                  ),
                  Offstage(
                    offstage: value != PageName.SETTINGS,
                    child: SettingsPage(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
