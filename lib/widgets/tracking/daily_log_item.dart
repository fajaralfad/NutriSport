import 'package:flutter/material.dart';
import 'package:nutrisport/models/daily_log.dart';
import 'metric_chip.dart';

class DailyLogItem extends StatelessWidget {
  final DailyLog log;
  final bool isDark;

  const DailyLogItem({
    super.key,
    required this.log,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[50],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildMetrics(),
          if (log.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildNotes(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${log.date.day}/${log.date.month}/${log.date.year}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${log.caloriesConsumed.round()} kcal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: [
        MetricChip(
          icon: Icons.monitor_weight_rounded,
          label: '${log.weight}kg',
          color: Colors.blue,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        MetricChip(
          icon: Icons.water_drop_rounded,
          label: '${log.waterConsumed}L',
          color: Colors.cyan,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700]!.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[600]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notes_rounded,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              log.notes,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}