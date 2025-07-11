// lib/widgets/weekday_selector.dart

import 'package:flutter/material.dart';

class WeekdaySelector extends StatelessWidget {
  final List<Map<String, String>> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const WeekdaySelector({
    Key? key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onDaySelected(index),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white12,
                child: Text(
                  days[index]['day']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                days[index]['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
