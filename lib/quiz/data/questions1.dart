import '../models/quiz_question.dart';

const questions = [
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
];
