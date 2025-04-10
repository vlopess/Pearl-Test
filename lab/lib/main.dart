import 'dart:mirrors' show InstanceMirror, MethodMirror, reflect;

import '../../lib/src/annotations/annotation.dart';
import '../../lib/src/extensions/extensions.dart';






void main(List<String> arguments) {
  final InstanceMirror reflectedClassTest = reflect(ClassTest());
  late MethodMirror? setUpAnnotation;
  late MethodMirror? tearDownAnnotation;
  int count = 1;
  

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
    
    if(methodMirror.metadata.firstWhereOrNull((metadata) => metadata.reflectee is Disabled) != null) return;

    final RepeatedTest? repeatedTestAnnotation = methodMirror.metadata.
                                              firstWhereOrNull((metadata) => metadata.reflectee is RepeatedTest)?.reflectee;

    if (repeatedTestAnnotation != null) {
      count = repeatedTestAnnotation.value;
    }

    if (testMethod != null) {
      for (var i = 0; i < count; i++) {
        reflectedClassTest.invoke(setUpAnnotation!.simpleName, []);
        reflectedClassTest.invoke(methodMirror.simpleName, []);
        reflectedClassTest.invoke(tearDownAnnotation!.simpleName, []);
      }
    }

  });

}

class ClassTest {

  @BeforeEach()
  void setUp() {
    print("Before Each Test");
    print("=====================");
  }

  @AfterEach()
  void tearDown() {
    print("=====================");
    print("After Each Test");
    print("---------------------");
  }

  @Test()
  @RepeatedTest(value: 3)
  void test1(){
    print('Eu sou o teste 1 e repito várias vezes');
  }

  @Test()
  void test2(){
    print('Eu sou o teste 2.');
  }

  @Test()
  //@Disabled()
  void test3(){
    print('Eu sou o teste 3.');
  }

}

