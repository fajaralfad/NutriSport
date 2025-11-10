import 'package:flutter/material.dart';

class HydrationTracker extends StatelessWidget {
  final double currentAmount;
  final double targetAmount;
  final Function(double) onUpdate;

  const HydrationTracker({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentAmount / targetAmount;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Progress Hidrasi Hari Ini',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    color: _getProgressColor(progress),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${currentAmount.toStringAsFixed(1)}L',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ ${targetAmount.toStringAsFixed(1)}L',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWaterButton(0.25, '+250ml'),
                _buildWaterButton(0.5, '+500ml'),
                _buildWaterButton(1.0, '+1L'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterButton(double amount, String label) {
    return ElevatedButton.icon(
      onPressed: () => onUpdate(currentAmount + amount),
      icon: const Icon(Icons.add),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[50],
        foregroundColor: Colors.blue,
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }
}