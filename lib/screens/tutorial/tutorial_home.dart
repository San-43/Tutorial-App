import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final User user = FirebaseAuth.instance.currentUser!;
  String? userName;
  String? userImage;

  // List of tutorial units using the Unit model
  final List<Unit> units = const [
    Unit(
      title: '¿Qué es Flutter?',
      subtitle: 'Un kit de desarrollo de UI de código abierto creado por Google.',
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

  @override
  void initState() {
    super.initState();
    userName = user.displayName;
    userImage = user.photoURL;

    _controller = VideoPlayerController.asset('assets/tutorial_video.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    UserFirestoreService().getProgress().then((value) {
      setState(() {
        progress = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? displayName = userName;
    final String avatarUrl = userImage ?? 'default_avatar.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: Text(
          'Welcome $displayName, you are in!',
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
                    userImage = user.photoURL ?? 'default_avatar.png';
                  });
                }
              },
              itemBuilder: (context) => [
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
              child: userAvatar(avatarUrl),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: units.length,
          itemBuilder: (context, index) {
            final unit = units[index];
            final bool isActive = index <= progress - 1;
            final bool isHovered = hoverIndex == index;

            Color baseColor = isActive ? Colors.redAccent : Colors.grey.shade300;
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
                  onTap: isActive
                      ? () {
                    // TODO: navigate to unit details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Clicked: ${unit.title}')),
                    );
                  }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unit.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            color: isActive ? Colors.white : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          unit.subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: isActive ? Colors.white70 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
