import 'dart:mirrors' show InstanceMirror, MethodMirror, reflect;

import 'package:petal_test/src/annotations/annotation.dart';
import 'package:petal_test/src/extensions/extensions.dart';






void main(List<String> arguments) {
  final InstanceMirror reflectedClassTest = reflect(ClassTest());
  late MethodMirror? setUpAnnotation;
  late MethodMirror? tearDownAnnotation;
  

  reflectedClassTest.type.instanceMembers.forEach((_, MethodMirror methodMirror){
    if (methodMirror.isOperator || !methodMirror.isRegularMethod) return;
  

    final BeforeEach? setUp = methodMirror.metadata
        .firstWhereOrNull((metadata) => metadata.reflectee is BeforeEach)
        ?.reflectee;
    if(setUp != null) setUpAnnotation = methodMirror;

    final AfterEach? tearDown = methodMirror.metadata
        .firstWhereOrNull((metadata) => metadata.reflectee is AfterEach)?.reflectee;
    if(tearDown != null) tearDownAnnotation = methodMirror;

  });


  reflectedClassTest.type.instanceMembers.forEach((_, MethodMirror methodMirror){
    if (methodMirror.isOperator || !methodMirror.isRegularMethod) return;

    final InstanceMirror? testMethod = methodMirror.metadata
        .firstWhereOrNull((metadata) => metadata.reflectee is Test);
    
    if (testMethod != null) {
      reflectedClassTest.invoke(setUpAnnotation!.simpleName, []);
      reflectedClassTest.invoke(methodMirror.simpleName, []);
      reflectedClassTest.invoke(tearDownAnnotation!.simpleName, []);
    }

  });

}

class ClassTest {

  @BeforeEach()
  void setUp() {
    print('Executa antes de cada método');
  }

  @AfterEach()
  void tearDown() {
    print('Executa depois de cada método');
  }

  @Test()
  void test1(){
    print('Eu sou o teste 1.');
  }

  @Test()
  void test2(){
    print('Eu sou o teste 2.');
  }

}

