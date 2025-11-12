import 'package:flutter/material.dart';
import 'package:nutrisport/utils/progress_utils.dart';

class ChartSelectionSection extends StatelessWidget {
  final bool isDark;
  final String selectedChart;
  final Function(String) onChartChanged;

  const ChartSelectionSection({
    super.key,
    required this.isDark,
    required this.selectedChart,
    required this.onChartChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildDecoration(),
      child: Column(
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 16),
          _buildChartSelector(),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bar_chart_rounded, color: Colors.purple, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Grafik Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment<String>(
          value: 'weight',
          label: Text('Berat'),
          icon: Icon(Icons.monitor_weight_rounded, size: 18),
        ),
        ButtonSegment<String>(
          value: 'water',
          label: Text('Hidrasi'),
          icon: Icon(Icons.water_drop_rounded, size: 18),
        ),
        ButtonSegment<String>(
          value: 'calories',
          label: Text('Kalori'),
          icon: Icon(Icons.local_fire_department_rounded, size: 18),
        ),
      ],
      selected: <String>{selectedChart},
      onSelectionChanged: (Set<String> newSelection) {
        onChartChanged(newSelection.first);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ProgressUtils.getChartColor(selectedChart);
            }
            return isDark ? Colors.grey[800]! : Colors.grey[100]!;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return isDark ? Colors.grey[400]! : Colors.grey[700]!;
          },
        ),
      ),
    );
  }
}