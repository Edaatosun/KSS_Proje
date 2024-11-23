import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<RecognizedText> processImage(InputImage inputImage) async {
  // final textDetector = GoogleMlKit.vision.textRecognizer(); //! deprecated olduğu için kaldırıldı, çalışıyordu. sorun çıkarsa google_ml_kit geri dön.
  final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
  RecognizedText recognizedText = await textDetector.processImage(inputImage);
  await textDetector.close();

  return recognizedText;
}

Future<Map<String, String>> detectMedicineText(InputImage inputImage) async {
  RecognizedText recognizedText = await processImage(inputImage);

  String frequencyResult = "";
  String hungerSituation = "";
  String hungerSituationResult = "";
  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      if ((line.text.contains("SABAH") || line.text.contains("sabah") || line.text.contains("Sabah")) && !frequencyResult.contains("08:00")) {
        if (frequencyResult.isEmpty) {
          frequencyResult += "08:00";
        } else {
          frequencyResult += ", 08:00";
        }
      }
      if ((line.text.contains("ÖĞLE") ||
              line.text.contains("Ögle") ||
              line.text.contains("Ogle") ||
              line.text.contains("ogle") ||
              line.text.contains("öğle") ||
              line.text.contains("Öğle") ||
              line.text.contains("GÜNDE 1") ||
              line.text.contains("GUNDE 1") ||
              line.text.contains("Günde 1") ||
              line.text.contains("Gunde 1") ||
              line.text.contains("günde 1") ||
              line.text.contains("gunde 1")) &&
          !frequencyResult.contains("12:00")) {
        if (frequencyResult.isEmpty) {
          frequencyResult += "12:00";
        } else {
          frequencyResult += ", 12:00";
        }
      }
      if ((line.text.contains("AKŞAM") ||
              line.text.contains("akşam") ||
              line.text.contains("Akşam") ||
              line.text.contains("AKSAM") ||
              line.text.contains("AK\$AM")) &&
          !frequencyResult.contains("20:00")) {
        if (frequencyResult.isEmpty) {
          frequencyResult += "20:00";
        } else {
          frequencyResult += ", 20:00";
        }
      }

      if (line.text.contains("GÜNDE 2") ||
          line.text.contains("GUNDE 2") ||
          line.text.contains("Günde 2") ||
          line.text.contains("Gunde 2") ||
          line.text.contains("günde 2") ||
          line.text.contains("gunde 2") ||
          line.text.contains("GÜNDE iki") ||
          line.text.contains("GUNDE iki") ||
          line.text.contains("Günde iki") ||
          line.text.contains("Gunde iki") ||
          line.text.contains("günde iki") ||
          line.text.contains("gunde iki")) {
        frequencyResult = "08:00, 20:00";
      }

      if (line.text.contains("GÜNDE 3") ||
          line.text.contains("GUNDE 3") ||
          line.text.contains("Günde 3") ||
          line.text.contains("Gunde 3") ||
          line.text.contains("günde 3") ||
          line.text.contains("gunde 3") ||
          line.text.contains("GÜNDE üç") ||
          line.text.contains("GUNDE üç") ||
          line.text.contains("Günde üç") ||
          line.text.contains("Gunde üç") ||
          line.text.contains("günde üç") ||
          line.text.contains("gunde üç")) {
        frequencyResult = "08:00, 12:00, 20:00";
      }

      if (line.text.contains("GÜNDE 4") ||
          line.text.contains("GUNDE 4") ||
          line.text.contains("Günde 4") ||
          line.text.contains("Gunde 4") ||
          line.text.contains("günde 4") ||
          line.text.contains("gunde 4") ||
          line.text.contains("GÜNDE dört") ||
          line.text.contains("GUNDE dört") ||
          line.text.contains("Günde dört") ||
          line.text.contains("Gunde dört") ||
          line.text.contains("günde dört") ||
          line.text.contains("gunde dört")) {
        frequencyResult = "08:00, 12:00, 16:00, 20:00";
      }

      if (line.text.contains("GÜNDE 5") ||
          line.text.contains("GUNDE 5") ||
          line.text.contains("Günde 5") ||
          line.text.contains("Gunde 5") ||
          line.text.contains("günde 5") ||
          line.text.contains("gunde 5") ||
          line.text.contains("GÜNDE beş") ||
          line.text.contains("GUNDE beş") ||
          line.text.contains("Günde beş") ||
          line.text.contains("Gunde beş") ||
          line.text.contains("günde beş") ||
          line.text.contains("gunde beş")) {
        frequencyResult = "08:00, 12:00, 16:00, 20:00, 24:00";
      }

      //* ***********************************************************
      if ((line.text.contains("AÇ") ||
              line.text.contains("aç") ||
              line.text.contains("Aç") ||
              line.text.contains("Ac") ||
              line.text.contains("ac") ||
              line.text.contains("AC")) &&
          !hungerSituation.contains("Aç")) {
        hungerSituation += "Aç ";
      }
      if ((line.text.contains("TOK") || line.text.contains("tok") || line.text.contains("Tok")) && !hungerSituation.contains("Tok")) {
        hungerSituation += "Tok ";
      }

      hungerSituationResult = await checkHungerSituation(hungerSituation);
    }
  }

  return {"hungerSituationResult": hungerSituationResult, "frequencyResult": frequencyResult};
}

Future<String> checkHungerSituation(String hungerSituation) async {
  String result = "";
  if (hungerSituation.contains("Aç") && (!hungerSituation.contains("Tok"))) {
    result = "Aç karnına";
  }

  if (hungerSituation.contains("Tok") && (!hungerSituation.contains("Aç"))) {
    result = "Tok karnına";
  } else {
    result = "Aç veya tok karnına";
  }
  return result;
}
