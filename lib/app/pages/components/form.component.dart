import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:questions_task/app/core/configs.dart';
import 'package:questions_task/app/core/geoLocator.dart';
import 'package:questions_task/app/model/math_question.model.dart';
import 'package:questions_task/app/pages/components/text_field_input.component.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNum = TextEditingController();
  final TextEditingController _secondNum = TextEditingController();
  final TextEditingController _delay = TextEditingController();
  bool _enableGPS = false;
  int _operationIndex = -1;
  Position? _userPosition;

  Color getColor(Set<MaterialState> states) {
    return Theme.of(context).primaryColor;
  }

  @override
  void initState() {
    super.initState();
    GeoLocatorImpl().determinePosition().then((pos) => _userPosition = pos);
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          children: [
            Expanded(
              child: TextFieldInput(
                firstNum: _firstNum,
                text: 'First Number',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    _buildShowModalBottomSheet(context);
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
                child: TextFieldInput(
              firstNum: _secondNum,
              text: 'Second Number',
            )),
          ],
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 60),
                  child: TextFieldInput(
                    firstNum: _delay,
                    text: 'Delay in seconds',
                  )),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Show Location'),
                leading: Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: _enableGPS,
                  onChanged: (bool? value) async {
                    setState(() {
                      _enableGPS = !_enableGPS;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _enableGPS && _userPosition != null,
          child: _buildMapRow(context),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _operationIndex != -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: const Text('Submitting your question'),
                  ),
                );
                FlutterBackgroundService().sendData({
                  "action": Config.addKey,
                  'question': MathQuestion(
                          seconds: int.parse(_delay.text),
                          firstNum: double.parse(_firstNum.text),
                          secondNum: double.parse(_secondNum.text),
                          operator:
                              MathOperation.values[_operationIndex].symbol,
                          duration: DateTime.now()
                              .add(Duration(seconds: int.parse(_delay.text))))
                      .toJson()
                });
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
      ]),
    );
  }

  Container _buildMapRow(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .18,
      child: Column(
        children: [
          Text(_userPosition == null
              ? ''
              : 'lat: ${_userPosition!.latitude}, long: ${_userPosition!.longitude}'),
          if (_userPosition != null)
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(_userPosition!.latitude, _userPosition!.longitude),
                  zoom: 11.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> _buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
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
                    child: Text(MathOperation.values[index].name),
                  ),
                ),
              );
            },
          );
        });
  }
}
