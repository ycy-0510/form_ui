import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.light)),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark)),
      themeMode: themeMode,
      home: ScaffoldMessenger(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Form Ui Example'),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                    value: themeMode,
                    borderRadius: BorderRadius.circular(15),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Row(spacing: 4, children: [
                          Icon(Icons.brightness_auto),
                          Text('Auto'),
                        ]),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Row(spacing: 4, children: [
                          Icon(Icons.brightness_7),
                          Text('Light'),
                        ]),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Row(spacing: 4, children: [
                          Icon(Icons.brightness_2),
                          Text('Dark'),
                        ]),
                      )
                    ],
                    onChanged: (v) {
                      setState(() {
                        themeMode = v!;
                      });
                    }),
              )
            ],
          ),
          body: HomeBody(),
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: min(500, MediaQuery.of(context).size.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                PositionSelectPart(),
                CheckBoxPart(),
                CounterPart(),
                SelectPart(),
                FormTextInput(
                  hintText: 'Hint Text',
                  labelText: 'Label Text',
                  onEditingComplete: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Text inputed!',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 300),
                    ));
                  },
                ),
                FormPrimaryButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Primary Button pressed!',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 300),
                      ));
                    },
                    child: Text(
                      'Primary',
                      style: TextStyle(fontSize: 20),
                    )),
                FormPrimaryButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Primary Danger Button pressed!',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 300),
                      ));
                    },
                    style: FormPrimaryButton.dangerStyle,
                    child: Text(
                      'Primary Danger',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
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
                FormSecondaryButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Secondary Danger Button pressed!',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 300),
                      ));
                    },
                    style: FormSecondaryButton.dangerStyle,
                    child: Text(
                      'Secondary Danger',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectPart extends StatefulWidget {
  const SelectPart({super.key});

  @override
  State<SelectPart> createState() => _SelectPartState();
}

class _SelectPartState extends State<SelectPart> {
  int? value;
  @override
  Widget build(BuildContext context) {
    return FormSelect<int>(
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Selected: $v',
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 300),
        ));
      },
    );
  }
}

class CounterPart extends StatefulWidget {
  const CounterPart({super.key});

  @override
  State<CounterPart> createState() => _CounterPartState();
}

class _CounterPartState extends State<CounterPart> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return FormCounter(
      hint: 'Counter',
      max: 1000,
      min: 0,
      value: value,
      onChange: (v) {
        setState(() {
          value = v;
        });
      },
    );
  }
}

class CheckBoxPart extends StatefulWidget {
  const CheckBoxPart({super.key});

  @override
  State<CheckBoxPart> createState() => _CheckBoxPartState();
}

class _CheckBoxPartState extends State<CheckBoxPart> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return FormCheckBox(
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
  }
}

class PositionSelectPart extends StatefulWidget {
  const PositionSelectPart({super.key});

  @override
  State<PositionSelectPart> createState() => _PositionSelectPartState();
}

class _PositionSelectPartState extends State<PositionSelectPart> {
  Offset? position;
  bool flip = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  Rect.fromLTRB(43.5374149659864, 11.1975116640747,
                      46.8537414965986, 88.4914463452566),
                  Rect.fromLTRB(46.8537414965986, 11.1975116640747,
                      53.1462585034014, 46.9673405909798),
                  // Rect.fromLTRB(53.1462585034014, 11.1975116640747,
                  //     56.4625850340136, 88.4914463452566),
                  // Rect.fromLTRB(46.8537414965986, 53.343701399689,
                  //     53.1462585034014, 88.4914463452566)
                ],
                // showAllowSelectZone: true,
                position: position,
                onChange: (value) {
                  setState(() {
                    position = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Posistion Selected: (${value.dx.toStringAsFixed(2)},${value.dy.toStringAsFixed(2)} )',
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(milliseconds: 300),
                  ));
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
  }

  Future<ByteData> getBgBytes() async {
    return await rootBundle.load('assets/example.png');
  }
}
