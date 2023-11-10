import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<String?> uploadAudioForTranscription(String assetPath) async {
  var uri = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

  var request = http.MultipartRequest('POST', uri)
    ..headers.addAll({
      'Authorization': 'Bearer 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',
      'Content-Type': 'multipart/form-data',
    });

  try {
    final file = File(assetPath);

    // Check if file exists
    if (!await file.exists()) {
      return 'File not found!';
    } else {
      if (kDebugMode) {
        print("file exists");
      }
    }

    Uint8List bytes = await file.readAsBytes();

    // Create a MultipartFile from the byte data
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'audio.m4a', // Set a filename (required for MultipartFile)
      contentType: MediaType('audio', 'mpeg'),
    );

    request.files.add(multipartFile);
    request.fields['model'] = 'whisper-1';
    request.fields['language'] = 'es'; // pt, es, en, de, fr
    request.fields['response_format'] = 'text'; // json, text

    if (kDebugMode) {
      print("uploading");
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('File uploaded successfully');
      }
      // Process the response if needed
      var body = await response.stream.bytesToString();
      if (kDebugMode) {
        //print(body);
        return body;
      }
    } else {
      if (kDebugMode) {
        print('Failed to upload file: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error uploading file: $e');
    }
  }
  return null;
}
