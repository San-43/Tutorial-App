import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_app/bot/chat_screen.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';
import 'package:tutorial_app/quiz/quiz.dart';
import 'package:tutorial_app/utils/animated_border_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/user_Avatar.dart';
import '../../profile_details.dart';
import '../model/resource.dart';

class Topic extends StatefulWidget {
  const Topic({
    super.key,
    required this.resources,
    required this.images,
    required this.identifier,
    required this.index,
  });

  final int index;
  final String identifier;
  final List<String> images;
  final List<Resource> resources;

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  late int progress;

  void getProgress() async {
    try {
      final newProgress = await UserFirestoreService().getProgress();
      if (mounted) {
        setState(() {
          progress = newProgress;
        });
      }
    } catch (e) {
      debugPrint('Error fetching progress: $e');
      if (mounted) {
        setState(() {
          progress = 1; // Fallback value
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo obtener el progreso correctamente, por favor inténtelo más tarde',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.5;
    User? user = FirebaseAuth.instance.currentUser;
    String? userImage = user?.photoURL;
    getProgress();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.identifier,
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: .8),
                Theme.of(context).colorScheme.secondary.withValues(alpha: .8),
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
                  Navigator.of(context).pop();
                } else if (value == 'profile') {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileDetailScreen()),
                  );
                  setState(() {
                    userImage = user!.photoURL;
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        notchMargin: 6.0,
        height: 60,
        elevation: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.quiz, color: Color.fromRGBO(
                  0, 255, 150, 1.0),),
              label: Text('Ir al Quiz', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Quiz(progress: widget.index + 1),
                  ),
                );
              },
            ),
            const SizedBox(width: 16), // spacing from right edge
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        child: RepaintBoundary(
          child: AnimatedBorderIcon(
            icon: Container(
              margin: const EdgeInsets.all(5),
              width: 50,
              height: 50,
              padding: EdgeInsets.all(2),
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                "assets/images/quiz-logo.png",
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
      // Aplicamos un gradiente de fondo usando colores más suaves de los contenedores del Theme
      body: Column(
        children: [
          // Carrusel de imágenes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: PageView.builder(
                itemCount: widget.images.length,
                controller: PageController(viewportFraction: 1.0),
                itemBuilder: (context, index) {
                  return Image.asset(
                    widget.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: height,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recursos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.resources.length,
                      itemBuilder: (context, index) {
                        final res = widget.resources[index];
                        return InkWell(
                          onTap: () async {
                            final uri = Uri.parse(res.url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              setState(() => res.visited = true);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  res.visited
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                ),
                                SizedBox(width: 5),
                                // Expanded evita overflow dándole al Text el espacio disponible
                                Expanded(
                                  child: Text(
                                    res.title,
                                    style: TextStyle(
                                      color:
                                          res.visited
                                              ? Colors.purple
                                              : Colors.blue,
                                    ),
                                    maxLines: 1, // como mucho una línea
                                    overflow:
                                        TextOverflow
                                            .ellipsis, // recorta con “…”
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
