import 'package:flutter/material.dart';

class RiskMapScreen extends StatefulWidget {
  final String userType;
  
  const RiskMapScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<RiskMapScreen> createState() => _RiskMapScreenState();
}

class _RiskMapScreenState extends State<RiskMapScreen> {
  String _selectedDisease = 'All';
  bool _showSatelliteView = false;
  
  final List<String> _diseases = ['All', 'Malaria', 'Dengue', 'Diarrhea', 'Malnutrition'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Risk Map',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D8A),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showSatelliteView ? Icons.map : Icons.satellite),
            onPressed: () {
              setState(() {
                _showSatelliteView = !_showSatelliteView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Disease Filter:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _diseases.map((disease) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(disease),
                                selected: _selectedDisease == disease,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedDisease = disease;
                                  });
                                },
                                selectedColor: const Color(0xFF2E7D8A),
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: _selectedDisease == disease 
                                    ? Colors.white 
                                    : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'View:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _showSatelliteView,
                      onChanged: (value) {
                        setState(() {
                          _showSatelliteView = value;
                        });
                      },
                      activeColor: const Color(0xFF2E7D8A),
                    ),
                    Text(
                      _showSatelliteView ? 'Satellite' : 'Map',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Map placeholder
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Stack(
                children: [
                  // Map placeholder
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: _showSatelliteView ? Colors.brown[100] : Colors.green[50],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showSatelliteView ? Icons.satellite : Icons.map,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _showSatelliteView ? 'Satellite View' : 'Interactive Map',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Showing $_selectedDisease Risk Zones',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Risk zones overlay
                  _buildRiskZonesOverlay(),
                  
                  // Legend
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskZonesOverlay() {
    return Stack(
      children: [
        // High risk zone
        Positioned(
          top: 100,
          left: 50,
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.3),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Center(
              child: Text(
                'HIGH RISK\nDengue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        
        // Medium risk zone
        Positioned(
          top: 200,
          right: 60,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: const Center(
              child: Text(
                'MEDIUM\nMalaria',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        
        // Low risk zone
        Positioned(
          bottom: 120,
          left: 80,
          child: Container(
            width: 90,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Center(
              child: Text(
                'LOW RISK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Levels',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem('High Risk', Colors.red),
          _buildLegendItem('Medium Risk', Colors.orange),
          _buildLegendItem('Low Risk', Colors.green),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
