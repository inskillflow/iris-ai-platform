import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/iris_models.dart';
import '../widgets/probability_chart.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  double _sepalLength = 5.1;
  double _sepalWidth = 3.5;
  double _petalLength = 1.4;
  double _petalWidth = 0.2;

  PredictionResponse? _prediction;
  bool _isLoading = false;
  String? _error;

  static const _speciesColors = {
    'setosa': Color(0xFF4CAF50),
    'versicolor': Color(0xFF2196F3),
    'virginica': Color(0xFF9C27B0),
  };

  static const _speciesIcons = {
    'setosa': '🌸',
    'versicolor': '🌺',
    'virginica': '🌷',
  };

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = PredictionRequest(
        sepalLength: _sepalLength,
        sepalWidth: _sepalWidth,
        petalLength: _petalLength,
        petalWidth: _petalWidth,
      );
      final response = await _apiService.predict(request);
      setState(() {
        _prediction = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildInputForm(),
          const SizedBox(height: 24),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_error != null) _buildError(),
          if (_prediction != null) ...[
            _buildResultCard(),
            const SizedBox(height: 16),
            ProbabilityChart(probabilities: _prediction!.probabilities),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_florist, size: 48, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'Prédiction Iris',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Entrez les mesures de la fleur pour identifier son espèce',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mesures de la fleur',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildSlider(
                'Longueur sépale (cm)',
                _sepalLength,
                4.0,
                8.0,
                (v) => setState(() => _sepalLength = v),
              ),
              _buildSlider(
                'Largeur sépale (cm)',
                _sepalWidth,
                2.0,
                4.5,
                (v) => setState(() => _sepalWidth = v),
              ),
              _buildSlider(
                'Longueur pétale (cm)',
                _petalLength,
                1.0,
                7.0,
                (v) => setState(() => _petalLength = v),
              ),
              _buildSlider(
                'Largeur pétale (cm)',
                _petalWidth,
                0.1,
                2.5,
                (v) => setState(() => _petalWidth = v),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _predict,
                  icon: const Icon(Icons.science),
                  label: const Text(
                    'Prédire l\'espèce',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 10).round(),
            activeColor: const Color(0xFF667eea),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final species = _prediction!.species;
    final color = _speciesColors[species] ?? Colors.grey;
    final icon = _speciesIcons[species] ?? '🌼';
    final confidence = (_prediction!.confidence * 100).toStringAsFixed(1);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              species.toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Confiance: $confidence%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
