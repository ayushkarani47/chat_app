import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class MLModelPage extends StatefulWidget {
  @override
  _MLModelPageState createState() => _MLModelPageState();
}

class _MLModelPageState extends State<MLModelPage> {
  String _prediction = 'No prediction yet';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/mnist_model.tflite',
      labels: 'assets/labels.txt',
    );
    print('Model loading status: $res');
  }

  Future<void> predict() async {
    var output = await Tflite.runModelOnImage(
      path: 'assets/test_image.png', // Add your test image here
      numResults: 1,
    );
    setState(() {
      _prediction = output != null ? output[0]['label'] : 'No prediction';
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Model Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Prediction: $_prediction'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predict,
              child: Text('Run Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}
