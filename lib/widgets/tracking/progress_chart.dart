import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutrisport/utils/progress_utils.dart';

class ProgressChart extends StatelessWidget {
  final bool isDark;
  final String chartType;
  final List<FlSpot> data;

  const ProgressChart({
    super.key,
    required this.isDark,
    required this.chartType,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildDecoration(),
      child: Column(
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 20),
          _buildChart(),
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
            color: ProgressUtils.getChartColor(chartType).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            ProgressUtils.getChartIcon(chartType),
            color: ProgressUtils.getChartColor(chartType),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          ProgressUtils.getChartTitle(chartType),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    // Jika data kosong, tampilkan placeholder
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    // Urutkan data berdasarkan x (tanggal) dari terkecil ke terbesar
    final sortedData = List<FlSpot>.from(data)
      ..sort((a, b) => a.x.compareTo(b.x));

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getHorizontalInterval(sortedData),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: _getBottomTitles(sortedData)),
            leftTitles: AxisTitles(sideTitles: _getLeftTitles(sortedData)),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          minX: sortedData.first.x,
          maxX: sortedData.last.x,
          minY: _getMinY(sortedData),
          maxY: _getMaxY(sortedData),
          lineBarsData: [
            LineChartBarData(
              spots: sortedData,
              isCurved: true,
              color: ProgressUtils.getChartColor(chartType),
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ProgressUtils.getChartColor(chartType).withOpacity(0.3),
                    ProgressUtils.getChartColor(chartType).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: ProgressUtils.getChartColor(chartType),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 48,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada data untuk ditampilkan',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getHorizontalInterval(List<FlSpot> data) {
    if (data.isEmpty) return 1;

    final maxY = _getMaxY(data);
    final minY = _getMinY(data);
    final range = maxY - minY;

    // Sesuaikan interval berdasarkan range data dan tipe chart
    if (chartType == 'weight') {
      // Untuk berat badan, interval lebih kecil
      if (range <= 2) return 0.5;
      if (range <= 5) return 1;
      return 2;
    } else if (chartType == 'water') {
      // Untuk air, interval desimal
      if (range <= 1) return 0.2;
      if (range <= 2) return 0.5;
      return 1;
    } else {
      // Untuk kalori, interval lebih besar
      if (range <= 100) return 50;
      if (range <= 500) return 100;
      if (range <= 1000) return 200;
      return 500;
    }
  }

  double _getMinY(List<FlSpot> data) {
    if (data.isEmpty) return 0;

    double minY = data.first.y;
    for (final spot in data) {
      if (spot.y < minY) minY = spot.y;
    }

    // Berikan margin berdasarkan tipe chart
    switch (chartType) {
      case 'weight':
        return (minY - 0.5).clamp(0, double.infinity); // Margin 0.5 kg
      case 'water':
        return (minY - 0.2).clamp(0, double.infinity); // Margin 0.2 L
      case 'calories':
        return (minY * 0.9).clamp(0, double.infinity); // Margin 10%
      default:
        return (minY - 1).clamp(0, double.infinity);
    }
  }

  double _getMaxY(List<FlSpot> data) {
    if (data.isEmpty) {
      // Nilai default berdasarkan tipe chart
      switch (chartType) {
        case 'weight':
          return 80;
        case 'water':
          return 3;
        case 'calories':
          return 2000;
        default:
          return 10;
      }
    }

    double maxY = data.first.y;
    for (final spot in data) {
      if (spot.y > maxY) maxY = spot.y;
    }

    // Berikan margin berdasarkan tipe chart
    switch (chartType) {
      case 'weight':
        return maxY + 0.5; // Margin 0.5 kg
      case 'water':
        return maxY + 0.2; // Margin 0.2 L
      case 'calories':
        return maxY * 1.1; // Margin 10%
      default:
        return maxY + 1;
    }
  }

  SideTitles _getBottomTitles(List<FlSpot> data) {
    return SideTitles(
      showTitles: true,
      interval: _getXInterval(data),
      getTitlesWidget: (value, meta) {
        // Tampilkan label untuk titik data yang ada
        final hasData = data.any((spot) => spot.x == value);
        if (hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${value.toInt() + 1}',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  SideTitles _getLeftTitles(List<FlSpot> data) {
    return SideTitles(
      showTitles: true,
      interval: _getHorizontalInterval(data),
      reservedSize: 40, // Berikan ruang lebih untuk label
      getTitlesWidget: (value, meta) {
        // Format angka berdasarkan tipe chart
        String formattedValue = _formatYValue(value, chartType);

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            formattedValue,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.right,
          ),
        );
      },
    );
  }

  String _formatYValue(double value, String chartType) {
    switch (chartType) {
      case 'weight':
        return value.toStringAsFixed(1);
      case 'water':
        return value.toStringAsFixed(1);
      case 'calories':
        if (value >= 1000) {
          return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
        }
        return value.toInt().toString();
      default:
        return value.toStringAsFixed(1);
    }
  }

  double _getXInterval(List<FlSpot> data) {
    if (data.length <= 5) return 1;
    if (data.length <= 10) return 2;
    if (data.length <= 20) return 3;
    return (data.length / 6).ceilToDouble();
  }
}
