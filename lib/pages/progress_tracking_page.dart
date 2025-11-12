import 'package:flutter/material.dart';
import 'package:nutrisport/widgets/tracking/progress_info_banner.dart';
import 'package:nutrisport/widgets/tracking/progress_input_section.dart';
import 'package:nutrisport/widgets/tracking/chart_selection_section.dart';
import 'package:nutrisport/widgets/tracking/progress_chart.dart';
import 'package:nutrisport/widgets/tracking/recent_logs_section.dart';
import 'package:nutrisport/utils/progress_utils.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({super.key});

  @override
  State<ProgressTrackingPage> createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage>
    with SingleTickerProviderStateMixin {
  late final ProgressController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = ProgressController();
    _fadeAnimation = ProgressUtils.createFadeAnimation(this);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Tracking & Progress'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProgressInfoBanner(isDark: isDark),
              const SizedBox(height: 24),
              ProgressInputSection(
                isDark: isDark,
                controller: _controller,
                onSave: () => _handleSave(context),
              ),
              const SizedBox(height: 24),
              ChartSelectionSection(
                isDark: isDark,
                selectedChart: _controller.selectedChart,
                onChartChanged: _handleChartChanged,
              ),
              const SizedBox(height: 24),
              if (_controller.hasData) ...[
                ProgressChart(
                  isDark: isDark,
                  chartType: _controller.selectedChart,
                  data: _controller.getChartData(),
                ),
                const SizedBox(height: 24),
              ],
              RecentLogsSection(
                isDark: isDark,
                dailyLogs: _controller.dailyLogs,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (_controller.saveLog()) {
      setState(() {});
      ProgressUtils.showSuccessMessage(
        context,
        'Data harian berhasil disimpan!',
      );
    } else {
      ProgressUtils.showWarningMessage(
        context,
        'Masukkan berat badan terlebih dahulu',
      );
    }
  }

  void _handleChartChanged(String newChart) {
    setState(() {
      _controller.selectedChart = newChart;
    });
  }
}
