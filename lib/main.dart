import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'data/DatabaseHelper.dart';
import 'screens/StadiumCreationUpdateScreen.dart';
import 'screens/MyDynamicImageListScreen.dart';
import 'screens/StaticImageList.dart';
import 'data/studio_list.dart';
import 'shareable/DarkModeSwitcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/mkproject_icon');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if(studiomList.isNotEmpty){
    DatabaseHelper.createFirebaseRealtimeDBWithUniqueIDs("Studioms", studiomList);
  } else{

  }
  final databaseRef = FirebaseDatabase.instance.ref();
  DateTime now = DateTime.now();

  String formattedDateTime = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

  databaseRef.child("Test").push().set({"DateTime": formattedDateTime});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ThemeSwitcherWidget(
      child: Builder(
        builder: (context) {
          final themeMode = ThemeSwitcherWidget
              .of(context)
              ?.themeMode ?? ThemeMode.light;

          return MaterialApp(
            title: 'Project Mohammed',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.yellowAccent, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            // Apply the current theme mode
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = 'Stadium Reservation', this.initialIndex = 0});

  final String title;
  final int initialIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex; // Set the initial index
  }

  static List<Widget> widget_options = <Widget>[
    const MyDynamicImageListScreen(),
    const StaticImageList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ThemeSwitcherWidget.of(context)?.toggleTheme(),
          ),
        ],
        foregroundColor: Colors.white,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          )
        ),
      ),
      body: Center(
        child: widget_options.elementAt(selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        onTap: onTapPressed,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Available now",
            icon: Icon(Icons.stadium_outlined),
          ),
          BottomNavigationBarItem(
            label: "Listed Images",
            icon: Icon(Icons.stadium),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewStadium,
        tooltip: 'addNewStadium',
        foregroundColor: Colors.black,
        backgroundColor: Colors.white54,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onTapPressed(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  void addNewStadium() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StadiumCreationUpdateScreen(isUpdate: false),
      ),
    );
  }
}