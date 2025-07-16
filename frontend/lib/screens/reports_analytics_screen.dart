import 'package:flutter/material.dart';
import '../services/health_prediction_service.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  final String userType;
  
  const ReportsAnalyticsScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  String selectedTimeRange = 'Last 30 Days';
  String selectedDisease = 'All Diseases';
  Map<String, dynamic>? currentPrediction;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPredictionData();
  }

  Future<void> _loadPredictionData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final prediction = await HealthPredictionService.getCurrentHealthPrediction();
      setState(() {
        currentPrediction = prediction;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading prediction data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: const Color(0xFF2E7D8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadPredictionData,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            _buildFilterSection(),
            const SizedBox(height: 20),
            
            // Disease Trends
            _buildDiseaseAnalytics(),
            const SizedBox(height: 20),
            
            // Community Health Statistics
            _buildCommunityStats(),
            const SizedBox(height: 20),
            
            // Outbreak Predictions
            _buildOutbreakPredictions(),
            const SizedBox(height: 20),
            
            // Historical Data
            _buildHistoricalData(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D8A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip('Time Range', selectedTimeRange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterChip('Disease', selectedDisease),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D8A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2E7D8A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiseaseAnalytics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Disease Trend Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildDiseaseChart(),
          const SizedBox(height: 16),
          _buildDiseaseStats(),
        ],
      ),
    );
  }

  Widget _buildDiseaseChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: Color(0xFF2E7D8A),
            ),
            SizedBox(height: 8),
            Text(
              'Disease Trend Chart',
              style: TextStyle(
                color: Color(0xFF2E7D8A),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Interactive chart showing disease patterns',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseStats() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (currentPrediction == null || !currentPrediction!['success']) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Unable to load disease statistics',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final probabilities = currentPrediction!['probabilities'] as Map<String, dynamic>;
    final diseases = probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: diseases.map((entry) {
        final disease = entry.key;
        final probability = entry.value;
        final isHighest = entry == diseases.first;
        
        Color diseaseColor;
        switch (disease.toLowerCase()) {
          case 'malaria':
            diseaseColor = Colors.red;
            break;
          case 'dengue':
            diseaseColor = Colors.orange;
            break;
          case 'typhoid':
            diseaseColor = Colors.blue;
            break;
          case 'healthy':
            diseaseColor = Colors.green;
            break;
          default:
            diseaseColor = Colors.purple;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighest ? diseaseColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isHighest ? Border.all(color: diseaseColor, width: 2) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: diseaseColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    disease,
                    style: TextStyle(
                      fontWeight: isHighest ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${(probability * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isHighest ? diseaseColor : Colors.grey,
                    fontSize: 14,
                    fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isHighest) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.trending_up,
                    color: diseaseColor,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommunityStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Health Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildStatGrid(),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    final stats = [
      {'title': 'Total Population', 'value': '12,456', 'icon': Icons.people},
      {'title': 'High Risk Areas', 'value': '8', 'icon': Icons.warning},
      {'title': 'Active Cases', 'value': '23', 'icon': Icons.local_hospital},
      {'title': 'Recovered', 'value': '145', 'icon': Icons.health_and_safety},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D8A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                stat['icon'] as IconData,
                color: const Color(0xFF2E7D8A),
                size: 24,
              ),
              const Spacer(),
              Text(
                stat['value'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D8A),
                ),
              ),
              Text(
                stat['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutbreakPredictions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outbreak Prediction Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildPredictionTimeline(),
        ],
      ),
    );
  }

  Widget _buildPredictionTimeline() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (currentPrediction == null || !currentPrediction!['success']) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.warning_amber,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load prediction data',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final prediction = currentPrediction!['prediction'];
    final confidence = currentPrediction!['confidence'];
    final location = currentPrediction!['location'];
    
    // Get risk level and color
    final riskLevel = HealthPredictionService.getRiskLevel(prediction, confidence);
    final riskColor = HealthPredictionService.getRiskColor(riskLevel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            width: 4,
            color: riskColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Prediction: $prediction',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Location: $location',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: riskColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  riskLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last Updated: ${DateTime.now().toString().split('.')[0]}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Recommendations:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...HealthPredictionService.getRecommendations(prediction, confidence)
              .take(3)
              .map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHistoricalData() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historical Data Visualization',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D8A),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timeline,
                    size: 48,
                    color: Color(0xFF2E7D8A),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Historical Trends',
                    style: TextStyle(
                      color: Color(0xFF2E7D8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Long-term disease patterns and trends',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Time Range'),
                subtitle: Text(selectedTimeRange),
                onTap: () {
                  // Show time range picker
                },
              ),
              ListTile(
                title: const Text('Disease Type'),
                subtitle: Text(selectedDisease),
                onTap: () {
                  // Show disease picker
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Apply filters
                setState(() {});
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
