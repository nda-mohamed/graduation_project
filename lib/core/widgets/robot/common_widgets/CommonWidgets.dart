import 'package:flutter/material.dart';
import '../../../../core/app_theme/AppColors.dart';

class InfoBanner extends StatelessWidget {
  final VoidCallback onViewDetails;
  const InfoBanner({super.key, required this.onViewDetails});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColor.greenD,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Information about your plants today',
          style: TextStyle(color: AppColor.gray, fontSize: 14),
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.greenTP,
            foregroundColor: AppColor.green1,
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
          ),
          onPressed: onViewDetails,
          child: const Text(
            'View Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/robot/VD.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 120,
          ),
        ),
      ],
    ),
  );
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColor.greenD,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.gray,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 10),

        child,
      ],
    ),
  );
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}

class NutrientBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 – 1.0
  final String display;
  const NutrientBar({
    super.key,
    required this.label,
    required this.value,
    required this.display,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColor.green8, fontSize: 13),
          ),
          Text(
            display,
            style: const TextStyle(color: AppColor.green8, fontSize: 13),
          ),
        ],
      ),

      const SizedBox(height: 4),

      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: AppColor.greenUu,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.greenTP),
        ),
      ),
    ],
  );
}

class MiniLineChart extends StatelessWidget {
  final Color color;
  const MiniLineChart({super.key, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 60,
    child: CustomPaint(
      size: const Size(double.infinity, 60),
      painter: LinePainter(
        points: const [0.85, 0.3, 2, 0.2, 0.6, 0.2, -0.6, 0.4, 1, -0.5],
        color: color,
      ),
    ),
  );
}

class LinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  LinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final dx = size.width / (points.length - 1);

    // أول نقطة
    path.moveTo(0, size.height * (1 - points[0]));

    for (int i = 0; i < points.length - 1; i++) {
      final x1 = dx * i;
      final y1 = size.height * (1 - points[i]);

      final x2 = dx * (i + 1);
      final y2 = size.height * (1 - points[i + 1]);

      // control point (منتصف بينهم)
      final controlX = (x1 + x2) / 2;
      final controlY = (y1 + y2) / 2;

      path.quadraticBezierTo(x1, y1, controlX, controlY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColor.greenD,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColor.gray, size: 16),

            const SizedBox(width: 5),

            Text(
              label,
              style: const TextStyle(
                color: AppColor.gray,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

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
        color: AppColor.greenD,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColor.gray,
                  fontSize: 14,
                ),
              ),
              Text(badge, style: TextStyle(color: AppColor.gray, fontSize: 11)),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              color: AppColor.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 60,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: LinePainter(points: normalised, color: lineColor),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Mon',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Tue',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Wed',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Thu',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Fri',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Sat',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
              Text(
                'Sun',
                style: TextStyle(fontSize: 10, color: AppColor.gray),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const InsightCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Stack(
      children: [
        Image.asset(
          imagePath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Container(
          height: 180,
          width: double.infinity,
          color: Colors.black.withOpacity(0.3),
        ),

        Positioned(
          left: 12,
          bottom: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColor.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

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
    canvas.drawLine(const Offset(0, 70), Offset(size.width, 60), roadPaint);
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(FakeMapPainter _) => false;
}