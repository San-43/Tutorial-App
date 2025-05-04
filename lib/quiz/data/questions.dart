import '../models/quiz_question.dart';

const questions = [
  QuizQuestion(
    '¿Cuál es la palabra clave para declarar una variable entera en C++?',
    [
      'int',      // respuesta correcta
      'Integer',
      'var',
      'float',
    ],
  ),
  QuizQuestion(
    '¿Cómo se incluye un archivo de cabecera estándar en C++?',
    [
      '#include <iostream>',  // respuesta correcta
      'import iostream',
      'using namespace iostream',
      'include "iostream.h"',
    ],
  ),
  QuizQuestion(
    '¿Qué operador se usa para acceder a miembros de una clase a través de un puntero?',
    [
      '->',      // respuesta correcta
      '.',
      '::',
      '&',
    ],
  ),
  QuizQuestion(
    '¿Cuál es la sintaxis correcta de la función main en C++?',
    [
      'int main() { return 0; }',  // respuesta correcta
      'void main() { }',
      'main() {}',
      'int main(void) => { }',
    ],
  ),
  QuizQuestion(
    '¿Cómo se escribe un comentario de una sola línea en C++?',
    [
      '// comentario',  // respuesta correcta
      '/* comentario */',
      '# comentario',
      '<!-- comentario -->',
    ],
  ),
  QuizQuestion(
    '¿Cuál es la forma correcta de definir un espacio de nombres estándar?',
    [
      'using namespace std;',  // respuesta correcta
      'import std;',
      'namespace std;',
      'include <std>',
    ],
  ),
  QuizQuestion(
    '¿Cómo se declara una referencia a un entero?',
    [
      'int& ref = var;',  // respuesta correcta
      'int* ref = &var;',
      'ref<int> = var;',
      'int ref = &var;',
    ],
  ),
  QuizQuestion(
    '¿Cuál es la sintaxis de una plantilla de función genérica?',
    [
      'template<typename T> T func(T);',  // respuesta correcta
      'generic<T> T func(T);',
      'define<T> T func(T);',
      'template<T> func(T);',
    ],
  ),
  QuizQuestion(
    '¿Cómo se declara una clase derivada que hereda públicamente de Base?',
    [
      'class Derived : public Base {}',  // respuesta correcta
      'class Derived inherits Base {}',
      'class Derived : Base {}',
      'class Derived < public > Base {}',
    ],
  ),
  QuizQuestion(
    '¿Qué palabra clave se usa para una función que puede ser sobrescrita en clases derivadas?',
    [
      'virtual',  // respuesta correcta
      'override',
      'static',
      'inline',
    ],
  ),
  QuizQuestion(
    '¿Cómo se sobrecarga el operador suma para una clase MyClass?',
    [
      'MyClass operator+(const MyClass& other);',  // respuesta correcta
      'operator add(MyClass, MyClass);',
      'MyClass + (MyClass other);',
      'addOperator(MyClass a, MyClass b);',
    ],
  ),
  QuizQuestion(
    '¿Cuál es la forma correcta de asignar memoria dinámica para un entero?',
    [
      'int* p = new int;',  // respuesta correcta
      'int p = malloc(sizeof(int));',
      'int* p = malloc(int);',
      'auto p = alloc<int>();',
    ],
  ),
  QuizQuestion(
    '¿Cómo se maneja una excepción en C++?',
    [
      'try { } catch (const std::exception& e) { }',  // respuesta correcta
      'except (e) { }',
      'catch { }',
      'handle (e) { }',
    ],
  ),
  QuizQuestion(
    '¿Cómo se declara un método que no modificará el estado del objeto?',
    [
      'void func() const;',  // respuesta correcta
      'const void func();',
      'void const func();',
      'immutable void func();',
    ],
  ),
  QuizQuestion(
    '¿Qué contenedor STL se utiliza para una colección dinámica de elementos contiguos?',
    [
      'std::vector<int>',  // respuesta correcta
      'std::list<int>',
      'std::map<int,int>',
      'std::set<int>',
    ],
  ),
];