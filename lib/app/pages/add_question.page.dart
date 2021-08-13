import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MathOperation { ADD, SUB, MUL, DIV }

extension OperationExtension on MathOperation {
  String get symbol {
    switch (this) {
      case MathOperation.ADD:
        return '+';
      case MathOperation.SUB:
        return '-';
      case MathOperation.MUL:
        return '*';
      case MathOperation.DIV:
        return '/';
      default:
        return '+';
    }
  }

  String get name {
    switch (this) {
      case MathOperation.ADD:
        return 'Addition';
      case MathOperation.SUB:
        return 'Subtraction';
      case MathOperation.MUL:
        return 'Multiplication';
      case MathOperation.DIV:
        return 'Division';
      default:
        return 'Addition';
    }
  }
}

class AddQuestionPage extends StatefulWidget {
  static const String ROUTE_NAME = 'ADD_QUESTION_ROUTE';

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  bool _enableGPS = false;
  int _operationIndex = -1;
  bool _isPendingListEmpty = false;
  bool _isCompletedListEmpty = true;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions Task')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid value';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: MathOperation.values.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _operationIndex = index;
                                        });
                                      },
                                      child: ListTile(
                                        title: Center(
                                          child: Text(
                                              MathOperation.values[index].name),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                        child: _operationIndex == -1
                            ? const Text('ops')
                            : Text(
                                MathOperation.values[_operationIndex].symbol,
                                style: TextStyle(fontSize: 30),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Second Number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid value';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 60),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Delay in seconds',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if ((value != null && value.isNotEmpty) &&
                              int.tryParse(value) == null) {
                            return 'Please enter a valid value';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Show Location'),
                      leading: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: !_enableGPS,
                        onChanged: (bool? value) {
                          setState(() {
                            _enableGPS = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  //TODO: separate in presentation layer set value in message and call event here to submit
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _operationIndex != -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text('Submitting your question'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text('Validate your question'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TabBar(
                            indicatorColor: Theme.of(context).primaryColor,
                            isScrollable: true,
                            tabs: [
                              Text(
                                'Pending Questions',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                'Completed Questions',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _isPendingListEmpty
                                  ? Center(
                                      child: Text('Nothing to show'),
                                    )
                                  : ListView(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              _isCompletedListEmpty
                                  ? Center(
                                      child: Text('Nothing to show'),
                                    )
                                  : ListView(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '1 + 2 = ??',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child:
                                                    Text('Delay: 200 seconds'),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: Text('Location Sent'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
