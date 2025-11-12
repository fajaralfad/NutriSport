import 'package:flutter/material.dart';
import 'tip_item.dart';

class TipsSection extends StatelessWidget {
  final bool isDark;

  const TipsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;
        
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tips_and_updates_rounded,
                      color: Colors.green,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Flexible(
                    child: Text(
                      'Tips Pengaturan Pengingat',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              const TipItem('Pilih jam latihan yang sesuai dengan jadwal rutin Anda'),
              const TipItem('Aktifkan hanya pengingat yang diperlukan'),
              const TipItem('Pre-workout meal: 1-2 jam sebelum latihan'),
              const TipItem('Post-workout nutrition: dalam 30-60 menit setelah latihan'),
              const TipItem('Notifikasi akan muncul sesuai jadwal yang ditetapkan'),
              const TipItem('Pastikan izin notifikasi diaktifkan pada pengaturan perangkat'),
            ],
          ),
        );
      },
    );
  }
}