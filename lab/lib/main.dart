import 'dart:mirrors' show InstanceMirror, MethodMirror, reflect;

import 'package:petal_test/src/annotations/annotation.dart';
import 'package:petal_test/src/extensions/extensions.dart';






void main(List<String> arguments) {
  final InstanceMirror reflectedClassTest = reflect(ClassTest());
  MethodMirror? setUpAnnotation;
  MethodMirror? tearDownAnnotation;
  MethodMirror? beforeAllAnnotation;
  MethodMirror? afterAllAnnotation;
  MethodMirror? onlyOneAnnotation;
  List<dynamic>? params;
  int count = 1;
  

  reflectedClassTest.type.instanceMembers.forEach((_, MethodMirror methodMirror){
    if (methodMirror.isOperator || !methodMirror.isRegularMethod) return;
  

    if (setUpAnnotation == null) {
      final BeforeEach? setUp = methodMirror.metadata
          .firstWhereOrNull((metadata) => metadata.reflectee is BeforeEach)
          ?.reflectee;
      if(setUp != null) setUpAnnotation = methodMirror;      
    }

    if (tearDownAnnotation == null) {
      final AfterEach? tearDown = methodMirror.metadata
          .firstWhereOrNull((metadata) => metadata.reflectee is AfterEach)?.reflectee;
      if(tearDown != null) tearDownAnnotation = methodMirror;      
    }


    if (beforeAllAnnotation == null) {
      final BeforeAll? beforeAll = methodMirror.metadata
          .firstWhereOrNull((metadata) => metadata.reflectee is BeforeAll)
          ?.reflectee;
      if(beforeAll != null) beforeAllAnnotation = methodMirror;      
    }

    if (afterAllAnnotation == null) {
      final AfterAll? afterAll = methodMirror.metadata
          .firstWhereOrNull((metadata) => metadata.reflectee is AfterAll)?.reflectee;
      if(afterAll != null) afterAllAnnotation = methodMirror;      
    }    

    if (onlyOneAnnotation == null) {
      final Only? onlyOne = methodMirror.metadata
          .firstWhereOrNull((metadata) => metadata.reflectee is Only)?.reflectee;

      if(methodMirror.metadata.firstWhereOrNull((metadata) => 
                            metadata.reflectee is ParameterizedTest) != null){
        ValueSource? data = methodMirror.metadata.firstWhereOrNull((metadata) => 
                            metadata.reflectee is ValueSource)?.reflectee;

        if(data != null) params = data.currentData;                                                             
      }

      if(onlyOne != null && methodMirror.metadata.firstWhereOrNull((metadata) => metadata.reflectee is Disabled) == null) {
        onlyOneAnnotation = methodMirror;      
      }
    }     

  });


  if(beforeAllAnnotation != null) reflectedClassTest.invoke(beforeAllAnnotation!.simpleName, []);

  if (onlyOneAnnotation != null) {
    invoke(count,
     setUpAnnotation,
     reflectedClassTest,
     onlyOneAnnotation!,
     tearDownAnnotation);

  } else {
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
        if(methodMirror.metadata.firstWhereOrNull((metadata) => 
                            metadata.reflectee is ParameterizedTest) != null){
          ValueSource? data = methodMirror.metadata.firstWhereOrNull((metadata) => 
                              metadata.reflectee is ValueSource)?.reflectee;
                              
          if(data != null) params = data.currentData;                                                             
        }

        final DisplayName? displayTestAnnotation = methodMirror.metadata.
                                                firstWhereOrNull((metadata) => metadata.reflectee is DisplayName)?.reflectee;

        if(displayTestAnnotation != null) print("\t${displayTestAnnotation.displayName}:\n");

        invoke(count, setUpAnnotation, reflectedClassTest, methodMirror, tearDownAnnotation, values: params);
      }

    });
  }


  if(afterAllAnnotation != null) reflectedClassTest.invoke(afterAllAnnotation!.simpleName, []);

}

void invoke(int count, MethodMirror? setUpAnnotation, InstanceMirror reflectedClassTest, MethodMirror methodMirror, MethodMirror? tearDownAnnotation, {List<dynamic>? values = const []}) {
  if(values != null) count = values.length;
  for (var i = 0; i < count; i++) {
    if(setUpAnnotation != null) reflectedClassTest.invoke(setUpAnnotation.simpleName, []);
    reflectedClassTest.invoke(methodMirror.simpleName, [values?[i]]);
    if(tearDownAnnotation != null) reflectedClassTest.invoke(tearDownAnnotation.simpleName, []);
  }
}

class ClassTest {

  ///TODO: 
  ///Verificar a existência de somente um por classe
  ///Somente uma anotação
  @BeforeAll()
  void init(){
    print("Init Test");
    print("=====================");    
  }

  ///TODO: 
  ///Verificar a existência de somente um por classe
  ///Somente uma anotação
  @AfterAll()
  void dispose(){
    print("Dispose Test");
    print("=====================");    
  }

  ///TODO: 
  ///Verificar a existência de somente um por classe
  ///Somente uma anotação
  @BeforeEach()
  void setUp() {
    print("Before Each Test");
    print("=====================");
  }

  ///TODO: 
  ///Verificar a existência de somente um por classe
  ///Somente uma anotação
  @AfterEach()
  void tearDown() {
    print("=====================");
    print("After Each Test");
    print("---------------------");
  }

  ///TODO: 
  ///Uma anotação por método
  @Test()

  ///TODO: 
  ///Uma anotação por método
  @DisplayName(displayName: "Esse teste vai repetir várias vezes")
  
  ///TODO: 
  ///Uma anotação por método
  @RepeatedTest(value: 3)

  ///TODO: 
  ///Uma anotação por método
  @Disabled()
  void test1(){
    print('Eu sou o teste 1 e repito várias vezes');
  }

  @Test()
  @Disabled()
  @DisplayName(displayName: "Eu sou mais um teste")
  void test2(){
    print('Eu sou o teste 2.');
  }

  @Test()
  ///TODO: 
  ///Uma anotação por método
  @Only()
  void test3(){
    print('Eu sou o teste 3.');
  }

  @Test()

  ///TODO: 
  ///Uma anotação por método
  ///ParameterizedTest 1 -- 1 ValueSource
  ///ValueSource.T, sendo T == Type Param
  @ParameterizedTest()
  @ValueSource.int([1, 2, 3, 4, 5])
  void test4(int value){
    print("Eu sou o número $value");
  }
}

