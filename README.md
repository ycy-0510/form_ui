# Form UI
This is a simple and clean form UI package for flutter. It is a collection of different form elements like buttons, text inputs, select inputs, counter inputs, checkbox inputs, and position select inputs. You can use it in your flutter project to make your form more attractive and user-friendly.
## Demo
[Online Demo](https://flutterformui.netlify.app)

## Features

- [x] Easy to use
- [x] Simple and clean
## Getting started
## Prerequisites

Before you begin, ensure you have met the following requirements:
- You have installed Flutter on your development machine. You can download it from [flutter.dev](https://flutter.dev).
- You are using a supported operating system (Windows, macOS, or Linux).
- You have a basic understanding of Dart and Flutter.

## Installation

To install the package, follow these steps:

1. Add the package to your `pubspec.yaml` file:
    ```yaml
    dependencies:
      form_ui: ^latest_version
    ```
2. Install the package by running:
    ```sh
    flutter pub get
    ```

For more detailed information on how to get started with Flutter, visit the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

## Usage

### Button
Primary Button
```dart
 FormPrimaryButton(
    onPressed: () {
        print('Primary Button');
    },
    child: Text(
        'Primary',
        style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    )),
```
You can also add danger style in it.
```dart
 style: FormPrimaryButton.dangerStyle,
```
Secondary Button
```dart
FormSecondaryButton(
    onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Secondary Button pressed!',
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 300),
        ));
    },
    child: Text(
        'Secondary',
        style: TextStyle(fontSize: 20),
    )),
```
You can also add danger style in it.
```dart
 style: FormSecondaryButton.dangerStyle,
```

### Input
Text Input
```dart
 FormTextInput(
    hintText: 'Hint Text',
    labelText: 'Label Text',
    onEditingComplete: () {
        print('Editing Complete');
    },
    onChanged: (value) {
        print(value);
    },
),
```
Select Input
```dart
FormSelect<int>(
      hint: 'Please Select You Name',
      value: value,
      items: [
        DropdownMenuItem(value: 1, child: Text('First')),
        DropdownMenuItem(value: 2, child: Text('Second')),
        DropdownMenuItem(value: 3, child: Text('Third')),
      ],
      onChange: (int? v) {
        setState(() {
          value = v;
        });
        print(value);
      },
    );
```
Counter Input
```dart
FormCounter(
      hint: 'Counter',
      max: 1000,
      min: 0,
      value: value,
      onChange: (v) {
        setState(() {
          value = v;
        });
        print(value);
      },
    );
```
Checkbox Input
```dart
FormCheckBox(
      value: value,
      hint: 'Check Box',
      onChange: (v) {
        setState(() {
          value = v;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Checkbox: ${v ? 'Checked' : 'Unchecked'}',
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 300),
        ));
      },
    );
```

Position Select Input
```dart
Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormCheckBox(
          value: flip,
          hint: 'Flip',
          onChange: (value) {
            setState(() {
              flip = value;
            });
          },
        ),
        FutureBuilder(
          future: getBgBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FormPositionSelect(
                bytes: snapshot.data!.buffer.asUint8List(),
                allowSelectZone: [
                  Rect.fromLTRB(45, 10,
                      46, 90),
                ],//allow to select only this zone, you can add multiple zone
                showAllowSelectZone: true,//default is false
                position: position,
                onChange: (value) {
                    setState(() {
                        position = value;
                    });
                    print(value);
                },
                flip: flip,
              );
            } else {
              return Center(
                child: Text('Reading Bytes'),
              );
            }
          },
        ),
      ],
    );
```

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

All image assets are **NOT** included in this package. You NEED to use your own image assets.
