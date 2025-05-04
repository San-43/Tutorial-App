import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';
import 'package:tutorial_app/quiz/quiz.dart';
import 'package:tutorial_app/screens/auth/welcome_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black,
          primary: Color(0xFF00599C), // Azul fuerte del logo de C++
          onPrimary: Colors.white, // Texto blanco sobre fondo azul
          secondary: Color(0xFF004482), // Un azul más oscuro como secundario
          onSecondary: Colors.white,
          tertiary: Color(
            0xFF87CEFA,
          ), // Azul claro para detalles (tipo skyblue)
          error: Colors.red,
          outline: Color(0xFF333333), // Gris oscuro para bordes
        ),
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // hay usuario: navegar a Quiz()
          return const Quiz();
        }
        // no hay usuario: mostrar login
        return const WelcomeScreen();
      },
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({super.key});

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<SharedPreferencesWithCache> _prefs =
  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // This cache will only accept the key 'counter'.
          allowList: <String>{'counter'}));
  late Future<int> _counter;
  int _externalCounter = 0;

  /// Completes when the preferences have been initialized, which happens after
  /// legacy preferences have been migrated.
  final Completer<void> _preferencesReady = Completer<void>();

  Future<void> _incrementCounter() async {
    final SharedPreferencesWithCache prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((_) {
        return counter;
      });
    });
  }

  /// Gets external button presses that could occur in another instance, thread,
  /// or via some native system.
  Future<void> _getExternalCounter() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final int externalCounter = (await prefs.getInt('externalCounter')) ?? 0;
    setState(() {
      _externalCounter = externalCounter;
    });
  }

  Future<void> _migratePreferences() async {
    // #docregion migrate
    const SharedPreferencesOptions sharedPreferencesOptions =
    SharedPreferencesOptions();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: prefs,
      sharedPreferencesAsyncOptions: sharedPreferencesOptions,
      migrationCompletedKey: 'migrationCompleted',
    );
    // #enddocregion migrate
  }

  @override
  void initState() {
    super.initState();
    _migratePreferences().then((_) {
      _counter = _prefs.then((SharedPreferencesWithCache prefs) {
        return prefs.getInt('counter') ?? 0;
      });
      _getExternalCounter();
      _preferencesReady.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferencesWithCache Demo'),
      ),
      body: Center(
        child: _WaitForInitialization(
          initialized: _preferencesReady.future,
          builder: (BuildContext context) => FutureBuilder<int>(
            future: _counter,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Button tapped ${snapshot.data ?? 0 + _externalCounter} time${(snapshot.data ?? 0 + _externalCounter) == 1 ? '' : 's'}.\n\n'
                          'This should persist across restarts.',
                    );
                  }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Waits for the [initialized] future to complete before rendering [builder].
class _WaitForInitialization extends StatelessWidget {
  const _WaitForInitialization({
    required this.initialized,
    required this.builder,
  });

  final Future<void> initialized;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initialized,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const CircularProgressIndicator();
        }
        return builder(context);
      },
    );
  }
}