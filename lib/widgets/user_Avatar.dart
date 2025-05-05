import 'dart:io';

import 'package:flutter/material.dart';

Widget userAvatar(String? photoUrl, {double radius = 24}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey.shade200,
    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
        ? FileImage(File(photoUrl))
        : null,
    child: (photoUrl == null || photoUrl.isEmpty)
        ? Icon(
      Icons.person,
      size: radius * 1.2,
      color: Colors.grey.shade600,
    )
        : null,
  );
}