import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressHeader extends StatelessWidget {
  final double percent;
  final String dateLabel;
  final VoidCallback onDatePressed;

  const ProgressHeader({
    super.key,
    required this.percent,
    required this.dateLabel,
    required this.onDatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircularPercentIndicator(
          radius: 60,
          lineWidth: 6,
          percent: percent,
          center: Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          progressColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white12,
        ),
        TextButton.icon(
          onPressed: onDatePressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: Text(dateLabel, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
