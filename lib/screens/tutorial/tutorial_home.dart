import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/screens/tutorial/data/images_list.dart';
import 'package:tutorial_app/screens/tutorial/data/resources_list.dart';
import 'package:tutorial_app/screens/tutorial/topics/topic.dart';
import 'package:tutorial_app/screens/tutorial/units.dart';
import 'package:video_player/video_player.dart';

import '../../firestore/user_firestore_service.dart';
import '../../widgets/user_Avatar.dart';
import '../profile_details.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {


  final List<Unit> units = const [
    Unit(
      title: '¿Qué es Flutter?',
      subtitle:
          'Un kit de desarrollo de UI de código abierto creado por Google.',
    ),
    Unit(
      title: 'Instalando Flutter y primeros pasos',
      subtitle: 'Cómo configurar tu entorno y ejecutar tu primera aplicación.',
    ),
    Unit(
      title: 'Tu primera app',
      subtitle: 'Construye y despliega una aplicación simple en Flutter.',
    ),
  ];

  int progress = 0;
  int? hoverIndex;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/tutorial_video.mp4');

    // Safely handle asynchronous operation for video initialization
    _initializeVideoPlayerFuture = _controller
        .initialize()
        .then((_) {
          if (mounted) {
            _controller.setLooping(true);
            _controller.play();
          }
        })
        .catchError((error) {
          print("Error initializing video: $error");
        });

    // Safely retrieve progress from Firestore
    UserFirestoreService()
        .getProgress()
        .then((value) {
          if (mounted) {
            setState(() {
              progress = value;
            });
          }
        })
        .catchError((error) {
          print("Error fetching progress: $error");
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName;
    String? userImage = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: Text(
          'Welcome $userName, you are in!',
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(.8),
                Theme.of(context).colorScheme.secondary.withOpacity(.8),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              onSelected: (value) async {
                if (value == 'logout') {
                  await FirebaseAuth.instance.signOut();
                } else if (value == 'profile') {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileDetailScreen()),
                  );
                  setState(() {
                    userImage = user!.photoURL ?? 'default_avatar.png';
                  });
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Text('Ver perfil'),
                    ),
                    const PopupMenuItem(value: 'about', child: Text('About')),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text('Cerrar sesión'),
                    ),
                  ],
              child: userAvatar(userImage),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...List.generate(units.length, (index) {
              final unit = units[index];
              final bool isActive = index <= progress - 1;
              final bool isHovered = hoverIndex == index;

              Color baseColor =
                  isActive ? (index < progress-1 ? Colors.green : Colors.redAccent): Colors.grey.shade300;

              Color hoverColor = isActive ? Colors.green.shade700 : baseColor;

              return MouseRegion(
                onEnter: (_) {
                  if (isActive) setState(() => hoverIndex = index);
                },
                onExit: (_) {
                  if (isActive) setState(() => hoverIndex = null);
                },
                child: Card(
                  color: isHovered ? hoverColor : baseColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isActive ? 6 : 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap:
                        isActive
                            ? () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => Topic(
                                        resources: resourcesList[index+1]!,
                                        images: imagesList[index+1]!,
                                        identifier: units[index].title,
                                        index: index,
                                      ),
                                ),
                              );
                              setState(() {
                                userImage = user!.photoURL;
                              });
                            }
                            : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Por favor, termine los temas anteriores primero',
                                  ),
                                ),
                              );
                            },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              color: isActive ? Colors.white : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            unit.subtitle,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: isActive ? Colors.white70 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            FutureBuilder<void>(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
