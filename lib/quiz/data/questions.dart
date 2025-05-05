import '../models/quiz_question.dart';

// Mapa de preguntas agrupadas por tema:
// 0: preguntas iniciales
// 1: ¿Qué es Flutter?
// 2: Instalando Flutter
// 3: Tu primera app en Flutter
final Map<int, List<QuizQuestion>> questions = {
  0: [
    QuizQuestion(
      '¿Qué es Flutter?',
      [
        'Un kit de desarrollo de UI de código abierto creado por Google.',  // correcta
        'Un lenguaje de programación para inteligencia artificial.',
        'Una base de datos para aplicaciones móviles.',
        'Un sistema operativo para dispositivos móviles.',
      ],
    ),
    QuizQuestion(
      '¿Qué lenguaje de programación se utiliza principalmente en Flutter?',
      [
        'Dart',  // correcta
        'Java',
        'Kotlin',
        'Swift',
      ],
    ),
    QuizQuestion(
      '¿Qué widget en Flutter se utiliza para organizar elementos en una columna?',
      [
        'Column',  // correcta
        'Row',
        'Stack',
        'Container',
      ],
    ),
    QuizQuestion(
      '¿Cuál de los siguientes widgets permite desplazar una lista de elementos?',
      [
        'ListView',  // correcta
        'GridView',
        'Column',
        'Stack',
      ],
    ),
    QuizQuestion(
      '¿Qué significa que Flutter use "hot reload"?',
      [
        'Permite ver los cambios en la app al instante sin reiniciarla.',  // correcta
        'Recarga automáticamente la batería del dispositivo.',
        'Optimiza la ejecución del código en segundo plano.',
        'Recarga todos los paquetes y dependencias desde cero.',
      ],
    ),
  ],
  1: [
    QuizQuestion(
      '¿Qué es Flutter?',
      [
        'Un framework de UI móvil, web y de escritorio de código abierto de Google.', // correcta
        'Un lenguaje de programación.',
        'Un sistema de gestión de bases de datos.',
        'Un servicio de alojamiento en la nube.',
      ],
    ),
    QuizQuestion(
      '¿Cuál es la arquitectura principal de Flutter?',
      [
        'Widgets, Engine y Platform-specific Embedder.', // correcta
        'MVC (Modelo-Vista-Controlador).',
        'MVVM (Modelo-Vista-ViewModel).',
        'Client-Server.',
      ],
    ),
    QuizQuestion(
      '¿Cómo Flutter dibuja la UI en pantalla?',
      [
        'Usando su propio motor de renderizado Skia.', // correcta
        'Usando componentes nativos de Android y iOS.',
        'Usando HTML y CSS.',
        'Usando OpenGL directamente.',
      ],
    ),
  ],
  2: [
    QuizQuestion(
      '¿Cuál es el primer paso para instalar Flutter en tu equipo?',
      [
        'Descargar el SDK de Flutter desde flutter.dev.', // correcta
        'Clonar el repositorio de GitHub de Flutter.',
        'Instalar Android Studio únicamente.',
        'Ejecutar el comando `flutter run`.',
      ],
    ),
    QuizQuestion(
      '¿Qué variable de entorno debes configurar para Flutter?',
      [
        'PATH apuntando a la carpeta bin de Flutter.', // correcta
        'FLUTTER_HOME apuntando a la carpeta src.',
        'ANDROID_HOME apuntando al SDK de Android.',
        'DART_SDK apuntando al SDK de Dart.',
      ],
    ),
    QuizQuestion(
      '¿Qué comando verifica que tu instalación de Flutter esté completa?',
      [
        'flutter doctor', // correcta
        'flutter check',
        'flutter validate',
        'dart doctor',
      ],
    ),
    QuizQuestion(
      '¿Qué IDE recomiendan oficialmente para desarrollo en Flutter?',
      [
        'Android Studio o Visual Studio Code.', // correcta
        'Xcode exclusivamente.',
        'Eclipse.',
        'NetBeans.',
      ],
    ),
    QuizQuestion(
      '¿Qué plugin es necesario instalar en VS Code para Flutter?',
      [
        'Flutter y Dart.', // correcta
        'Java Extension Pack.',
        'Kotlin Plugin.',
        'C# for Visual Studio.',
      ],
    ),
    QuizQuestion(
      '¿Cómo actualizas el channel de Flutter a la versión estable?',
      [
        'flutter channel stable && flutter upgrade', // correcta
        'flutter switch stable',
        'flutter update stable',
        'dart channel stable',
      ],
    ),
    QuizQuestion(
      '¿Qué comando descarga las dependencias definidas en pubspec.yaml?',
      [
        'flutter pub get', // correcta
        'flutter packages install',
        'dart get',
        'flutter fetch',
      ],
    ),
    QuizQuestion(
      '¿Cómo instalas un emulador de Android desde la terminal?',
      [
        'sdkmanager "system-images;android-30;google_apis;x86"', // correcta
        'avdmanager create emulator',
        'flutter emulators --install',
        'android create avd',
      ],
    ),
    QuizQuestion(
      '¿Qué herramienta configura el dispositivo iOS para desarrollo?',
      [
        'Xcode y sus simuladores.', // correcta
        'Android Studio.',
        'flutter ios-setup',
        'dart ios-config',
      ],
    ),
    QuizQuestion(
      '¿Qué comando limpia el build de Flutter?',
      [
        'flutter clean', // correcta
        'flutter reset',
        'flutter clear',
        'dart clean',
      ],
    ),
  ],
  3: [
    QuizQuestion(
      '¿Cómo creas tu primera app en Flutter desde la terminal?',
      [
        'flutter create nombre_app', // correcta
        'flutter init nombre_app',
        'dart create nombre_app',
        'flutter start nombre_app',
      ],
    ),
    QuizQuestion(
      '¿Qué archivo contiene el punto de entrada de una app Flutter?',
      [
        'lib/main.dart', // correcta
        'android/app/src/main.dart',
        'pubspec.yaml',
        'index.html',
      ],
    ),
    QuizQuestion(
      '¿Qué comando usas para ejecutar tu app Flutter en un emulador?',
      [
        'flutter run', // correcta
        'flutter launch',
        'dart run',
        'flutter start',
      ],
    ),
    QuizQuestion(
      '¿Qué widget envuelve toda tu app para aplicar tema y rutas?',
      [
        'MaterialApp', // correcta
        'Scaffold',
        'Container',
        'WidgetsApp',
      ],
    ),
    QuizQuestion(
      '¿Cómo agregas un paquete externo en tu proyecto?',
      [
        'Agregándolo en pubspec.yaml y corriendo flutter pub get.', // correcta
        'Importándolo directamente en el código.',
        'Copiando los archivos al directorio lib.',
        'Usando dart install paquete.',
      ],
    ),
    QuizQuestion(
      '¿Qué widget utilizas para mostrar texto simple?',
      [
        'Text', // correcta
        'Label',
        'Paragraph',
        'StringWidget',
      ],
    ),
    QuizQuestion(
      '¿Cómo refrescas el estado de un StatefulWidget?',
      [
        'Llamando a setState()', // correcta
        'Llamando a refresh()',
        'Reconstruyendo MaterialApp.',
        'Usando StatefulBuilder.',
      ],
    ),
    QuizQuestion(
      '¿Qué widget proporciona una estructura básica con AppBar y body?',
      [
        'Scaffold', // correcta
        'Container',
        'Row',
        'Column',
      ],
    ),
    QuizQuestion(
      '¿Cuál es la diferencia principal entre StatelessWidget y StatefulWidget?',
      [
        'StatefulWidget mantiene estado mutable; StatelessWidget no.', // correcta
        'StatelessWidget es más rápido.',
        'StatefulWidget no tiene build().',
        'No hay diferencia.',
      ],
    ),
    QuizQuestion(
      '¿Cómo navegas a otra pantalla en Flutter?',
      [
        'Navigator.push(context, MaterialPageRoute(...))', // correcta
        'Routing.navigate()',
        'AppNavigator.push()',
        'Navigator.open()',
      ],
    ),
  ],
};
