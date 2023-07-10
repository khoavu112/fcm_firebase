import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:test_fcm_notification/firebase_api.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize cho Local Notification
  await NotificationController.initializeLocalNotifications(debug: true);

  // Initialize cho Push Notification
  await NotificationController.initializeRemoteNotifications(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notifController = NotificationController();

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem thử có Notification permission chưa nè
    notifController.checkPermission();
    // Đoạn này gọi hàm để log ra cái FCM Token nè.
    notifController.requestFirebaseToken();
    notifController.startListeningNotificationEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Gọi sự kiện gửi Notification
            notifController.localNotification();
          },
          child: Icon(Icons.circle_notifications),
        ),
      ),
    );
  }
}
