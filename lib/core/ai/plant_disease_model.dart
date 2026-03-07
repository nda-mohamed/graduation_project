import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantDiseaseModel {
  late Interpreter interpreter;

  Future loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/models/DD/vgg_model.tflite',
    );
  }

  /// تحويل الصورة إلى Tensor
  List preprocessImage(File imageFile) {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

    img.Image resized = img.copyResize(image, width: 224, height: 224);

    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          var pixel = resized.getPixel(x, y);

          return [
            pixel.r.toDouble() / 255.0,
            pixel.g.toDouble() / 255.0,
            pixel.b.toDouble() / 255.0,
          ];
        }),
      ),
    );

    return input;
  }

  List runModel(File imageFile) {
    var input = preprocessImage(imageFile);
    var output = List.filled(1 * 3, 0).reshape([1, 3]);
    interpreter.run(input, output);
    return output[0];
  }
}
