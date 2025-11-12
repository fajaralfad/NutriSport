import 'package:flutter/material.dart';

class HydrationInfoBanner extends StatelessWidget {
  final bool isDark;

  const HydrationInfoBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.cyan[700]!.withOpacity(0.3), Colors.cyan[900]!.withOpacity(0.3)]
              : [Colors.cyan[50]!, Colors.cyan[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.cyan[700]!.withOpacity(0.3) : Colors.cyan[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.water_drop_rounded,
              color: isDark ? Colors.cyan[300] : Colors.cyan[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Hidrasi yang tepat meningkatkan performa olahraga hingga 20%',
              style: TextStyle(
                color: isDark ? Colors.cyan[100] : Colors.cyan[900],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HydrationInputSection extends StatelessWidget {
  final bool isDark;
  final TextEditingController weightController;
  final TextEditingController durationController;
  final String intensity;
  final Function(String?) onIntensityChanged;
  final VoidCallback onCalculate;

  const HydrationInputSection({
    super.key,
    required this.isDark,
    required this.weightController,
    required this.durationController,
    required this.intensity,
    required this.onIntensityChanged,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 20),
          HydrationTextField(
            controller: weightController,
            label: 'Berat Badan (kg)',
            icon: Icons.monitor_weight_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          HydrationTextField(
            controller: durationController,
            label: 'Durasi Latihan (jam)',
            icon: Icons.timer_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          HydrationDropdown(
            value: intensity,
            label: 'Intensitas Latihan',
            icon: Icons.speed_rounded,
            items: const ['Ringan', 'Sedang', 'Berat'],
            onChanged: onIntensityChanged,
          ),
          const SizedBox(height: 24),
          CalculateButton(onCalculate: onCalculate),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.calculate_rounded, color: Colors.cyan, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Hitung Kebutuhan Hidrasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class HydrationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const HydrationTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
      ),
    );
  }
}

class HydrationDropdown extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;

  const HydrationDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
    );
  }
}

class CalculateButton extends StatelessWidget {
  final VoidCallback onCalculate;

  const CalculateButton({super.key, required this.onCalculate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.cyan, Colors.cyanAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onCalculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Hitung Kebutuhan Air',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HydrationProgressSection extends StatelessWidget {
  final bool isDark;
  final double currentAmount;
  final double targetAmount;
  final Function(double) onUpdate;

  const HydrationProgressSection({
    super.key,
    required this.isDark,
    required this.currentAmount,
    required this.targetAmount,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_drink_rounded, color: Colors.green, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Progress Hidrasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Import your existing HydrationTracker widget here
      ],
    );
  }
}

class HydrationTipsSection extends StatelessWidget {
  final bool isDark;

  const HydrationTipsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          const HydrationTipItem('Minum 500ml air 2 jam sebelum latihan'),
          const HydrationTipItem('Minum 150-250ml setiap 15-20 menit selama latihan'),
          const HydrationTipItem('Minum 500ml setelah latihan untuk rehidrasi'),
          const HydrationTipItem('Perhatikan warna urine - harus jernih'),
          const HydrationTipItem('Hindari minuman berkafein berlebihan'),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.lightbulb_rounded, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Tips Hidrasi Sehat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class HydrationTipItem extends StatelessWidget {
  final String text;

  const HydrationTipItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              size: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}