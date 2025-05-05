import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorial_app/firestore/user_firestore_service.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  File? _pickedImageFile;

  void _pickImage(bool camera) async {
    XFile? pickedImage;
    if (!camera) {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
      );
    }
    if (pickedImage == null) {
      return;
    }
    try {
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(pickedImage.path);
      await UserFirestoreService().updateUrlPhoto(urlPhoto: pickedImage.path);
      setState(() {
        _pickedImageFile = File(pickedImage!.path);
      });
    } catch (e) {
      setState(() {
        _pickedImageFile = null;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final displayName = user.displayName ?? '';
    final email = user.email ?? '';
    _pickedImageFile = user.photoURL != null ? File(user.photoURL!) : null;

    late final BoxDecoration gradientDecoration;

    gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Perfil')),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: gradientDecoration,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundImage:
                      _pickedImageFile != null
                          ? FileImage(_pickedImageFile!)
                          : null,
                  child:
                      _pickedImageFile == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    TextButton.icon(
                      onPressed: () => _pickImage(true),
                      icon: Icon(Icons.camera, color: Colors.white),
                      label: Text(
                        _pickedImageFile == null
                            ? 'Take a Photo'
                            : 'Update your Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(5),
                        shadowColor: WidgetStateProperty.all(
                          Colors.black.withValues(alpha: 0.5),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () => _pickImage(false),
                      icon: Icon(Icons.image, color: Colors.white),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(5),
                        shadowColor: WidgetStateProperty.all(
                          Colors.black.withValues(alpha: 0.5),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      label: Text(
                        'Choose from gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(email, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
