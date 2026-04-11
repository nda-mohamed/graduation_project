import 'package:flutter/material.dart';
import '../../../../core/app_theme/AppColors.dart';

// ============================================================
//  InfoBanner
// ============================================================
class InfoBanner extends StatelessWidget {
  final VoidCallback onViewDetails;
  const InfoBanner({super.key, required this.onViewDetails});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColor.cardBackground,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: const Text(
            'Information about your plants today',
            style: TextStyle(color: AppColor.textSecondary, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.green,
            foregroundColor: AppColor.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          onPressed: onViewDetails,
          child: const Text('View Details',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

// ============================================================
//  SectionCard
// ============================================================
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColor.cardBackground,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

// ============================================================
//  SectionLabel
// ============================================================
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          color: AppColor.white,
          fontWeight: FontWeight.bold,
          fontSize: 15));
}

// ============================================================
//  NutrientBar
// ============================================================
class NutrientBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 – 1.0
  final String display;
  const NutrientBar(
      {super.key,
        required this.label,
        required this.value,
        required this.display});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColor.textSecondary, fontSize: 12)),
          Text(display,
              style: const TextStyle(
                  color: AppColor.textSecondary, fontSize: 12)),
        ],
      ),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: AppColor.background,
          valueColor:
          const AlwaysStoppedAnimation<Color>(AppColor.green),
        ),
      ),
    ],
  );
}

// ============================================================
//  MiniLineChart
// ============================================================
class MiniLineChart extends StatelessWidget {
  final Color color;
  const MiniLineChart({super.key, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 60,
    child: CustomPaint(
      size: const Size(double.infinity, 60),
      painter: LinePainter(
        points: const [0.5, 0.3, 0.6, 0.2, 0.5, 0.35, 0.55, 0.4],
        color: color,
      ),
    ),
  );
}

// ============================================================
//  LinePainter
// ============================================================
class LinePainter extends CustomPainter {
  final List<double> points;
  final Color color;
  const LinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height - points[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LinePainter old) => false;
}

// ============================================================
//  StatCard
// ============================================================
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const StatCard(
      {super.key,
        required this.label,
        required this.value,
        required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColor.cardBackground,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColor.green, size: 16),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColor.textSecondary, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                color: AppColor.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// ============================================================
//  TrendCard
// ============================================================
class TrendCard extends StatelessWidget {
  final String label;
  final String badge;
  final String value;
  final Color valueColor;
  final Color lineColor;
  final List<double> points;
  const TrendCard({
    super.key,
    required this.label,
    required this.badge,
    required this.value,
    required this.valueColor,
    required this.lineColor,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final mx = points.reduce((a, b) => a > b ? a : b);
    final mn = points.reduce((a, b) => a < b ? a : b);
    final range = mx - mn == 0 ? 1.0 : (mx - mn).toDouble();
    final normalised = points.map((p) => (p - mn) / range).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColor.textSecondary, fontSize: 12)),
              Text(badge, style: TextStyle(color: valueColor, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: valueColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: LinePainter(points: normalised, color: lineColor),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Mon', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Tue', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Wed', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Thu', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Fri', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Sat', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
              Text('Sun', style: TextStyle(fontSize: 9, color: AppColor.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  InsightCard
// ============================================================
class InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const InsightCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 90,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColor.green.withOpacity(0.3)),
    ),
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColor.green, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColor.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );
}

// ============================================================
//  FakeMapPainter
// ============================================================
class FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF3A5A3A)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    final roadPaint = Paint()
      ..color = const Color(0xFF5A8A5A)
      ..strokeWidth = 4;
    canvas.drawLine(
        const Offset(0, 70), Offset(size.width, 60), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.4, 0),
        Offset(size.width * 0.45, size.height),
        roadPaint);
  }

  @override
  bool shouldRepaint(FakeMapPainter _) => false;
}