
![](https://raw.githubusercontent.com/vlopess/Pearl-Test/refs/heads/main/header.png)
## Petal Test

A minimalist, simple test package for Dart 

![status](https://img.shields.io/badge/status-not_started-brightgreen.svg?style=flat)


## ✨ Quick example
```dart
@ClassTestable()
class ClassTest {

  @BeforeEach()
  void setUp() {
    print("Before Each Test");
  }

  @AfterEach()
  void tearDown() {
    print("After Each Test");
  }

  @Disabled()
  @RepeatedTest(value: 3)
  @DisplayName(displayName: "Esse teste vai repetir várias vezes")
  void test1() {
    print('Eu sou o teste 1 e repito várias vezes');
  }

}
```

## 📚 Documentation

Full documentation will be available soon.

## 🤝 Contributing
Ideas, suggestions and PRs are welcome!
See [open issues](https://github.com/vlopess/Petal-Test/issues) or open a new one ✨

![](https://github.com/vlopess/Pearl-Test/blob/main/soon.GIF?raw=true)
