import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/iris_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<PredictionResponse> predict(PredictionRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PredictionResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur de prédiction: ${response.statusCode}');
    }
  }

  Future<ModelInfo> getModelInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/model/info'));

    if (response.statusCode == 200) {
      return ModelInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  Future<List<DatasetSample>> getDatasetSamples() async {
    final response = await http.get(Uri.parse('$baseUrl/dataset/samples'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => DatasetSample.fromJson(e)).toList();
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getDatasetStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dataset/stats'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }
}
