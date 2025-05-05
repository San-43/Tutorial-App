import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  });

  final String identifier;
  final List<String> images;
  final List<Resource> resources;

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  final User user = FirebaseAuth.instance.currentUser!;
  String? userName;
  String? userImage;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.5;
    final String avatarUrl = user.photoURL ?? 'default_avatar.png';

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
              child: userAvatar(avatarUrl),
            ),
          ),
        ],
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
                                Icon(res.visited ? Icons.check_circle : Icons.check_circle_outline ),
                                SizedBox(width: 5,),
                                Text(
                                  res.title,
                                  style: TextStyle(
                                    color:
                                    res.visited ? Colors.purple : Colors.blue,
                                  ),
                                ),
                              ],
                            )
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuizPage()),
                        );*/
                      },
                      child: Text(
                        'Ir al Quiz',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
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
