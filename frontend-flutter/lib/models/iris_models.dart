class PredictionRequest {
  final double sepalLength;
  final double sepalWidth;
  final double petalLength;
  final double petalWidth;

  PredictionRequest({
    required this.sepalLength,
    required this.sepalWidth,
    required this.petalLength,
    required this.petalWidth,
  });

  Map<String, dynamic> toJson() => {
        'sepal_length': sepalLength,
        'sepal_width': sepalWidth,
        'petal_length': petalLength,
        'petal_width': petalWidth,
      };
}

class PredictionResponse {
  final String species;
  final double confidence;
  final Map<String, double> probabilities;

  PredictionResponse({
    required this.species,
    required this.confidence,
    required this.probabilities,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      species: json['species'],
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: (json['probabilities'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}

class ModelInfo {
  final String modelType;
  final double accuracy;
  final List<String> featureNames;
  final List<String> targetNames;
  final Map<String, double> featureImportances;
  final int trainingSamples;
  final int testSamples;

  ModelInfo({
    required this.modelType,
    required this.accuracy,
    required this.featureNames,
    required this.targetNames,
    required this.featureImportances,
    required this.trainingSamples,
    required this.testSamples,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      modelType: json['model_type'],
      accuracy: (json['accuracy'] as num).toDouble(),
      featureNames: List<String>.from(json['feature_names']),
      targetNames: List<String>.from(json['target_names']),
      featureImportances: (json['feature_importances'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      trainingSamples: json['training_samples'],
      testSamples: json['test_samples'],
    );
  }
}

class DatasetSample {
  final double sepalLength;
  final double sepalWidth;
  final double petalLength;
  final double petalWidth;
  final String species;

  DatasetSample({
    required this.sepalLength,
    required this.sepalWidth,
    required this.petalLength,
    required this.petalWidth,
    required this.species,
  });

  factory DatasetSample.fromJson(Map<String, dynamic> json) {
    return DatasetSample(
      sepalLength: (json['sepal_length'] as num).toDouble(),
      sepalWidth: (json['sepal_width'] as num).toDouble(),
      petalLength: (json['petal_length'] as num).toDouble(),
      petalWidth: (json['petal_width'] as num).toDouble(),
      species: json['species'],
    );
  }
}
