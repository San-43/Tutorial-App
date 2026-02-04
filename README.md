# Tutorial App

Aplicación Flutter enfocada en aprendizaje interactivo con autenticación,
quiz inicial y un flujo principal de tutoriales. Integra Firebase para la
autenticación y persistencia de datos de usuario.

## Características

- Autenticación de usuarios con Firebase Auth.
- Quiz de inicio para habilitar el flujo principal.
- Pantallas de tutoriales y navegación basada en el estado de usuario.
- Tema y estilos personalizados.

## Requisitos

- Flutter (SDK estable recomendado).
- Configuración de Firebase para Android/iOS/Web según tu plataforma.
- Archivo `firebase_options.dart` generado por FlutterFire.

## Configuración rápida

1. Instala dependencias:
   ```bash
   flutter pub get
   ```
2. Configura Firebase (si aún no lo hiciste):
   ```bash
   flutterfire configure
   ```
3. Ejecuta la app:
   ```bash
   flutter run
   ```

## Estructura del proyecto (resumen)

- `lib/main.dart`: arranque de la app y enrutamiento por estado de sesión.
- `lib/screens/`: pantallas principales (auth, tutoriales, etc.).
- `lib/quiz/`: lógica y UI del quiz.
- `lib/firestore/`: servicios de acceso a Firestore.
- `lib/widgets/`: componentes reutilizables.

## Recursos

- Documentación de Flutter: https://docs.flutter.dev/
- Firebase para Flutter: https://firebase.flutter.dev/
